unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, StrUtils, Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    memInput: TMemo;
    memOutput: TMemo;
    grpMenu: TGroupBox;
    grpMenu2: TGroupBox;
    lblCount: TLabel;
    editRow: TLabeledEdit;
    udRow: TUpDown;
    boxType: TComboBox;
    chkSigned: TCheckBox;
    editIndent: TLabeledEdit;
    udIndent: TUpDown;
    chkDollar: TCheckBox;
    chk0s: TCheckBox;
    chkSpace: TCheckBox;
    dlgOpen: TOpenDialog;
    btnSave: TButton;
    btnOpen: TButton;
    dlgSave: TSaveDialog;
    btnSaveTxt: TButton;
    btnCopy: TButton;
    lblAbout: TLabel;
    btnClear: TButton;
    chkDecimal: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure memInputChange(Sender: TObject);
    procedure editRowChange(Sender: TObject);
    procedure editIndentChange(Sender: TObject);
    procedure boxTypeChange(Sender: TObject);
    procedure chkSignedClick(Sender: TObject);
    procedure chkDollarClick(Sender: TObject);
    procedure chk0sClick(Sender: TObject);
    procedure chkSpaceClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveTxtClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure chkDecimalClick(Sender: TObject);
  private
    { Private declarations }
    function Explode(s, d: string; n: integer): string;
    procedure GetInput;
    procedure Store(s: string; w: integer);
    procedure ShowOutput;
    function GetItem(pos, w: integer): string;
    function CleanNum(s: string; default, min: integer): string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  data: array of byte;
  enablegetinput: boolean;
const
  w2: array[1..4] of int64 = ($100,$10000,0,$100000000);

implementation

{$R *.dfm}

{ Replicate MediaWiki's "explode" string function. }
function TForm1.Explode(s, d: string; n: integer): string;
var n2: integer;
begin
  if (AnsiPos(d,s) = 0) and ((n = 0) or (n = -1)) then result := s // Output full string if delimiter not found.
  else
    begin
    if n > -1 then // Check for negative substring.
      begin
      s := s+d;
      n2 := n;
      end
    else
      begin
      d := AnsiReverseString(d);
      s := AnsiReverseString(s)+d; // Reverse string for negative.
      n2 := Abs(n)-1;
      end;
    while n2 > 0 do
      begin
      Delete(s,1,AnsiPos(d,s)+Length(d)-1); // Trim earlier substrings and delimiters.
      dec(n2);
      end;
    Delete(s,AnsiPos(d,s),Length(s)-AnsiPos(d,s)+1); // Trim later substrings and delimiters.
    if n < 0 then s := AnsiReverseString(s); // Un-reverse string if negative.
    result := s;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  enablegetinput := true;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  memInput.Width := (Form1.ClientWidth-21) div 2;
  memInput.Height := Form1.ClientHeight-grpMenu.Height-21;
  memOutput.Width := memInput.Width;
  memOutput.Height := memInput.Height;
  memOutput.Left := memInput.Width+13;
  grpMenu.Width := memInput.Width;
  grpMenu.Top := memInput.Height+13;
  grpMenu2.Width := memOutput.Width;
  grpMenu2.Top := grpMenu.Top;
  grpMenu2.Left := memOutput.Left;
  lblAbout.Left := grpMenu.Width-lblAbout.Width-4;
end;

{ Get data from input text and store in byte array. }
procedure TForm1.GetInput;
var i, j, w: integer;
  s: string;
begin
  for i := 0 to memInput.Lines.Count-1 do
    begin
    s := memInput.Lines[i]; // Get line.
    s := Explode(s,';',0); // Strip comments.
    s := ReplaceStr(s,#9,''); // Strip tabs.
    s := ReplaceStr(s,' ',''); // Strip spaces.
    w := 0;
    if AnsiPos('dc.b',s) <> 0 then
      begin
      s := Explode(s,'dc.b',1); // Strip dc.b.
      w := 1;
      end;
    if AnsiPos('dc.w',s) <> 0 then
      begin
      s := Explode(s,'dc.w',1); // Strip dc.w.
      w := 2;
      end;
    if AnsiPos('dc.l',s) <> 0 then
      begin
      s := Explode(s,'dc.l',1); // Strip dc.l.
      w := 4;
      end;
    j := 0;
    while Explode(s,',',j) <> '' do
      begin
      Store(Explode(s,',',j),w);
      inc(j);
      end;
    end;
end;

{ Convert string to bytes and store in array. }
procedure TForm1.Store(s: string; w: integer);
var i: int64;
  k: integer;
begin
  if TryStrtoInt64(s,i) = true then i := StrtoInt64(s) // Convert string to integer.
    else i := 0; // Use 0 if not valid.
  if i < 0 then i := w2[w]+i; // Convert i to unsigned.
  SetLength(data,Length(data)+w); // Extend data array.
  for k := 0 to w-1 do
    data[Length(data)-1-k] := (i shr (k*8)) and $ff; // Write byte to end of array.
end;

procedure TForm1.memInputChange(Sender: TObject);
begin
  if enablegetinput = true then
    begin
    SetLength(data,0); // Clear data array.
    GetInput; // Get input data.
    ShowOutput;
    end;
  if Length(data) < 10 then lblCount.Caption := InttoStr(Length(data))+' bytes found' // Update counter display.
  else lblCount.Caption := InttoStr(Length(data))+' ($'+InttoHex(Length(data),1)+') bytes found';
end;

{ Show contents of data array with new formatting. }
procedure TForm1.ShowOutput;
var i, j, w, items, fulllines, itemslastline, bytesleftover, pos: integer;
  s, indent: string;
begin
  editRow.Text := CleanNum(editRow.Text,16,1);
  editIndent.Text := CleanNum(editIndent.Text,2,0);
  indent := '';
  for i := 0 to StrtoInt(editIndent.Text)-1 do indent := #9+indent; // Add indents.
  memOutput.Lines.Clear; // Clear all lines.
  w := boxType.ItemIndex+1+(boxType.ItemIndex div 2); // Convert 0/1/2 to 1/2/4.
  items := Length(data) div w; // Total number of items.
  fulllines := items div StrtoInt(editRow.Text); // Number of full lines.
  itemslastline := items mod StrtoInt(editRow.Text); // Items on last line.
  bytesleftover := Length(data) mod w; // Leftover odd bytes after words/longwords.
  pos := 0;
  // Full lines.
  for i := 0 to fulllines-1 do
    begin
    s := boxType.Items[boxType.ItemIndex]+' '; // Write dc.b/w/l.
    for j := 0 to StrtoInt(editRow.Text)-1 do
      begin
      s := s+GetItem(pos,w)+', ';
      pos := pos+w;
      end;
    Delete(s,Length(s)-1,2); // Trim final comma and space.
    memOutput.Lines.Add(indent+s); // Write line.
    end;
  // Last line.
  if itemslastline > 0 then
    begin
    s := boxType.Items[boxType.ItemIndex]+' '; // Write dc.b/w/l.
    for j := 0 to itemslastline-1 do
      begin
      s := s+GetItem(pos,w)+', ';
      pos := pos+w;
      end;
    Delete(s,Length(s)-1,2); // Trim final comma and space.
    memOutput.Lines.Add(indent+s); // Write line.
    end;
  // Leftovers.
  if bytesleftover > 0 then
    begin
    s := 'dc.b '; // Write dc.b.
    for j := 0 to bytesleftover-1 do
      begin
      s := s+GetItem(pos,1)+', ';
      Inc(pos);
      end;
    Delete(s,Length(s)-1,2); // Trim final comma and space.
    memOutput.Lines.Add(indent+s); // Write line.
    end;
end;

{ Get byte/word/longword from data array and convert to string. }
function TForm1.GetItem(pos, w: integer): string;
var s, neg, dol, r: string;
  i, rwidth: integer;
  n: int64;
begin
  s := '';
  neg := '';
  dol := '$';
  n := 0;
  for i := 0 to w-1 do
    begin
    n := data[pos]+(n shl 8);
    Inc(pos);
    end;
  if chkSigned.Checked = true then
    if ((w = 1) and (n > $7f)) or ((w = 2) and (n > $7fff)) or ((w = 4) and (n > $7fffffff)) then
      begin
      n := w2[w]-n; // Convert to negative if signed.
      neg := '-'; // Use negative sign.
      end;
  if ((chkDollar.Checked = true) and (n < 10)) or (chkDecimal.Checked = true) then dol := ''; // Omit $ for 0-9 or decimal.
  if chkDecimal.Checked = false then s := InttoHex(n)
    else s := InttoStr(n);
  if chk0s.Checked = true then s := Copy(s,Length(s)-(w*2)+1,w*2) // Trim to width of byte/word/longword.
    else while (s[1] = '0') and (Length(s) > 1) do
      s := Copy(s,2,Length(s)-1); // Trim leading 0s.
  if chkDecimal.Checked = false then rwidth := (w*2)+1 // Width of output +1 for $.
    else rwidth := (w*2)+1+(w div 4); // Width of output for decimal.
  if chkSigned.Checked = true then Inc(rwidth); // +1 for negative sign.
  r := neg+dol+s;
  if chkSpace.Checked = true then
    while Length(r) < rwidth do r := ' '+r; // Pad with spaces.
  result := r;
end;

procedure TForm1.boxTypeChange(Sender: TObject);
begin
  ShowOutput;
end;

procedure TForm1.chk0sClick(Sender: TObject);
begin
  ShowOutput;
end;

procedure TForm1.chkDecimalClick(Sender: TObject);
begin
  ShowOutput;
end;

procedure TForm1.chkDollarClick(Sender: TObject);
begin
  ShowOutput;
end;

procedure TForm1.chkSignedClick(Sender: TObject);
begin
  ShowOutput;
end;

procedure TForm1.chkSpaceClick(Sender: TObject);
begin
  ShowOutput;
end;

procedure TForm1.editIndentChange(Sender: TObject);
begin
  ShowOutput;
end;

procedure TForm1.editRowChange(Sender: TObject);
begin
  ShowOutput;
end;

function TForm1.CleanNum(s: string; default, min: integer): string;
var i: integer;
begin
  if (s = '') or ((s = '0') and (min > 0)) then result := InttoStr(default) // Set to default if blank or 0.
  else if TryStrtoInt(s,i) = false then result := InttoStr(default) // Set to default if invalid.
  else result := s;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
var myfile: file;
  i: integer;
begin
  if dlgOpen.Execute then
    begin
    AssignFile(myfile,dlgOpen.FileName); // Get file.
    FileMode := fmOpenRead;
    Reset(myfile,1); // Read only.
    SetLength(data,FileSize(myfile));
    BlockRead(myfile,data[0],FileSize(myfile)); // Copy file to memory.
    CloseFile(myfile); // Close file.
    ShowOutput;
    enablegetinput := false; // Disable GetInput while text is copied.
    memInput.Clear;
    for i := 0 to memOutput.Lines.Count-1 do memInput.Lines.Add(memOutput.Lines[i]); // Copy text to input side.
    enablegetinput := true;
    end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
var myfile: file;
  fname: string;
begin
  if dlgSave.Execute then
    begin
    fname := dlgSave.FileName;
    if ExtractFileExt(fname) = '' then fname := fname+'.bin'; // Add .bin if no extension found.
    AssignFile(myfile,fname); // Create output file.
    ReWrite(myfile,1);
    BlockWrite(myfile,data[0],Length(data)); // Copy data to file.
    CloseFile(myfile);
    end;
end;

procedure TForm1.btnSaveTxtClick(Sender: TObject);
var myfile: file;
  fname: string;
begin
  if dlgSave.Execute then
    begin
    fname := dlgSave.FileName;
    if ExtractFileExt(fname) = '' then fname := fname+'.txt'; // Add .txt if no extension found.
    memOutput.Lines.SaveToFile(fname); // Save to file.
    end;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  memInput.Clear;
  SetLength(data,0); // Clear data array.
  memOutput.Clear;
  lblCount.Caption := '0 bytes found';
end;

procedure TForm1.btnCopyClick(Sender: TObject);
begin
  memOutput.SelectAll;
  memOutput.CopyToClipboard; // Copy output to clipboard.
end;

end.
