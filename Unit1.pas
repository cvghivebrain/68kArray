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
    UpDown1: TUpDown;
    procedure FormResize(Sender: TObject);
    procedure memInputChange(Sender: TObject);
  private
    { Private declarations }
    function Explode(s, d: string; n: integer): string;
    procedure GetInput;
    procedure Store(s: string; w: integer);
    procedure ShowOutput;
    function GetItem(pos, w: integer): string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  data: array of byte;

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
var i, k: integer;
begin
  if TryStrtoInt(s,i) = true then i := StrtoInt(s) // Convert string to integer.
    else i := 0; // Use 0 if not valid.
  if i < 0 then i := (1 shl (w*8))-i; // Convert i to unsigned.
  SetLength(data,Length(data)+w); // Extend data array.
  for k := 0 to w-1 do
    data[Length(data)-1-k] := (i shr (k*8)) and $ff; // Write byte to end of array.
end;

procedure TForm1.memInputChange(Sender: TObject);
begin
  SetLength(data,0); // Clear data array.
  GetInput; // Get input data.
  lblCount.Caption := InttoStr(Length(data))+' bytes found'; // Update counter display.
  ShowOutput;
end;

{ Show contents of data array with new formatting. }
procedure TForm1.ShowOutput;
var i, j, w, items, fulllines, itemslastline, bytesleftover, pos: integer;
  s: string;
begin
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
    memOutput.Lines.Add(s); // Write line.
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
    memOutput.Lines.Add(s); // Write line.
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
    memOutput.Lines.Add(s); // Write line.
    end;
end;

{ Get byte/word/longword from data array and convert to string. }
function TForm1.GetItem(pos, w: integer): string;
var s: string;
  i: integer;
begin
  s := '';
  for i := 0 to w-1 do
    begin
    s := s+InttoHex(data[pos],2);
    Inc(pos);
    end;
  result := '$'+s;
end;

end.
