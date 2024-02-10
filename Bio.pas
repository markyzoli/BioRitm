{***********************************************}
{ This project was created with the aim of      }
{ to record daily health events                 }
{***********************************************}
unit Bio;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    Vcl.ComCtrls, Vcl.TabNotBk, Vcl.ToolWin, Vcl.Grids;

type
    TFrm = class(TForm)
        TabbedNotebook1: TTabbedNotebook;
        Panel1: TPanel;
        DataList: TStringGrid;
        Panel2: TPanel;
        Button1: TButton;
        E_Megn: TEdit;              // Name input field
        E_Mertek: TEdit;            // Quantity/Measure input field
        Lista: TListBox;            // A list that supports the simplification of input
        RadioGroup1: TRadioGroup;   // Its setting indicates what the input is aimed at
        procedure FormCreate(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure E_MegnChange(Sender: TObject);
        procedure E_MegnEnter(Sender: TObject);
        procedure E_MegnExit(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure E_MertekEnter(Sender: TObject);
        procedure E_MertekExit(Sender: TObject);
        procedure RadioGroup1Click(Sender: TObject);
        procedure ListaClick(Sender: TObject);
        procedure E_MertekChange(Sender: TObject);
        procedure FormActivate(Sender: TObject);
        procedure TabbedNotebook1Click(Sender: TObject);
    private
        { Private declarations }
        Mezo: boolean;             // To record which input field is active
        // Lists of data to be displayed in the TListBox
        LBev: TStringList;
        LBevm: TStringList;
        LKi: TStringList;
        LKim: TStringList;
        LAll: TStringList;
        LAllm: TStringList;
        procedure Atszinez;        // Group data in StringGrid by date
        procedure MezokClear;      // Sets the input fields to default
        procedure UjAdat;          // Updates the data of the lists
    public
        procedure GridFrm;         // Setting cell widths
        function GetDatum(Sor: integer): string;  // Extracts the date from the DateTime data
        { Public declarations }
    end;

var
    Frm: TFrm;

implementation

{$R *.dfm}
// Save a TStringGrid to a file

procedure SaveStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
var
    f: TextFile;
    i, k: integer;
begin
    AssignFile(f, FileName);
    Rewrite(f);
    with StringGrid do
    begin
        // Write number of Columns/Rows
        Writeln(f, IntToStr(ColCount));
        Writeln(f, IntToStr(RowCount));
        // loop through cells
        for i := 0 to ColCount - 1 do
            for k := 0 to RowCount - 1 do
                Writeln(f, Cells[i, k]);
    end;
    CloseFile(f);
end;

// Load a TStringGrid from a file

procedure LoadStringGrid(StringGrid: TStringGrid; const FileName: TFileName);
var
    f: TextFile;
    i, k: integer;
    strTemp: String;
begin
    AssignFile(f, FileName);
    Reset(f);
    with StringGrid do
    begin
        // Get number of columns
        Readln(f, strTemp);
        ColCount := StrToInt(strTemp);
        // Get number of rows
        Readln(f, strTemp);
        RowCount := StrToInt(strTemp);
        // loop through cells & fill in values
        for i := 0 to ColCount - 1 do
            for k := 0 to RowCount - 1 do
            begin
                Readln(f, strTemp);
                Cells[i, k] := strTemp;
            end;
    end;
    CloseFile(f);
end;
// Save data - Update lists
procedure TFrm.Button1Click(Sender: TObject);
var
    S: string;
    x: integer;
begin
    // If one of the input fields has not received data, it exits
    if (E_Megn.Text = E_Megn.Hint) or (E_Mertek.Text = E_Mertek.Hint) then
        Exit;
    // Updates the data of the lists
    UjAdat;
    // Saving the data to the Grid
    with DataList do
    begin
        S := DateTimeToStr(Now);
        DataList.Cells[0, RowCount - 1] := S;
        DataList.Cells[1, RowCount - 1] := E_Megn.Text;
        DataList.Cells[2, RowCount - 1] := E_Mertek.Text;
        case RadioGroup1.ItemIndex of
            0:
                DataList.Cells[3, RowCount - 1] := 'Bevitel';
            1:
                DataList.Cells[3, RowCount - 1] := 'Kiadás';
            2:
                DataList.Cells[3, RowCount - 1] := 'Állapot';
        end;
        GridFrm; // Setting cell widths
        RowCount := RowCount + 1; // Prepares to receive the next data
    end;
    MezokClear; // Sets the input fields to default
    E_Megn.SetFocus; // Focuses on the "Name" field
end;
{ If the value of the field changes, it is based on the characters entered so far
  finds the appropriate one in the list, enters it in the field and selects the missing part }
procedure TFrm.E_MegnChange(Sender: TObject);
var
    S: string;
    i, x: integer;
begin
    // If you have deleted the contents of the field, it will be reset
    if E_Megn.Text = '' then
    begin
        E_Megn.Text := E_Megn.Hint;
        E_Megn.SelStart := 0;
        E_Megn.SelLength := Length(E_Megn.Text);
    end;
    if E_Megn.Text = E_Megn.Hint then
        E_Megn.Font.Color := clGrayText
    else
        E_Megn.Font.Color := clWindowText;
    // Search the list
    S := AnsiUpperCase(E_Megn.Text);
    for i := 0 to Lista.Items.Count - 1 do
    begin
        x := Pos(S, AnsiUpperCase(Lista.Items[i]));
        if x = 1 then
        begin
            Lista.ItemIndex := i;
            E_Megn.Text := Lista.Items[i];
            E_Megn.SelStart := Length(S);
            E_Megn.SelLength := Length(E_Megn.Text);
            Exit
        end;
    end;

end;

procedure TFrm.E_MegnEnter(Sender: TObject);
begin
    Mezo := True; // To record which input field is active
    // Basic situation
    if E_Megn.Text = E_Megn.Hint then
    begin
        E_Megn.Text := '';
        E_Megn.Font.Color := clWindowText;
    end;
    // Setting up the input support list
    case RadioGroup1.ItemIndex of
        0:
            Lista.Items.Assign(LBev);
        1:
            Lista.Items.Assign(LKi);
        2:
            Lista.Items.Assign(LAll);
    end;
end;

procedure TFrm.E_MegnExit(Sender: TObject);
begin
    if E_Megn.Text = '' then   // Basic situation
    begin
        E_Megn.Text := E_Megn.Hint;
        E_Megn.Font.Color := clGrayText;
    end;
end;

procedure TFrm.E_MertekChange(Sender: TObject);
var
    S: string;
    i, x: integer;
begin
    if E_Mertek.Text = '' then
    begin
        E_Mertek.Text := E_Mertek.Hint;
        E_Mertek.SelStart := 0;
        E_Mertek.SelLength := Length(E_Mertek.Text);
    end;

    S := AnsiUpperCase(E_Mertek.Text);
    for i := 0 to Lista.Items.Count - 1 do
    begin
        x := Pos(S, AnsiUpperCase(Lista.Items[i]));
        if x = 1 then
        begin
            Lista.ItemIndex := i;
            E_Mertek.Text := Lista.Items[i];
            E_Mertek.SelStart := Length(S);
            E_Mertek.SelLength := Length(E_Mertek.Text);
            Exit
        end;
    end;
end;

procedure TFrm.E_MertekEnter(Sender: TObject);
begin
    Mezo := False;
    if E_Mertek.Text = E_Mertek.Hint then
    begin
        E_Mertek.Text := '';
        E_Mertek.Font.Color := clWindowText;
    end;
    case RadioGroup1.ItemIndex of
        0:
            Lista.Items.Assign(LBevm);
        1:
            Lista.Items.Assign(LKim);
        2:
            Lista.Items.Assign(LAllm);
    end;
end;

procedure TFrm.E_MertekExit(Sender: TObject);
begin
    if E_Mertek.Text = '' then
    begin
        E_Mertek.Text := E_Mertek.Hint;
        E_Mertek.Font.Color := clGrayText;
    end;
end;

procedure TFrm.FormActivate(Sender: TObject);
begin
    RadioGroup1Click(RadioGroup1);
end;

procedure TFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    { TODO : Szövegek mentése }
    LBev.SaveToFile('bevitel.txt');
    LBevm.SaveToFile('bevitelm.txt');
    LKi.SaveToFile('kiadas.txt');
    LKim.SaveToFile('kiadasm.txt');
    LAll.SaveToFile('allapot.txt');
    LAllm.SaveToFile('allapotm.txt');
    DataList.RowCount := DataList.RowCount - 1;
    if DataList.Cells[0, 0] <> '' then
        SaveStringGrid(DataList, 'adatok.txt');
    LBev.Free;
    LBevm.Free;
    LKi.Free;
    LKim.Free;
    LAll.Free;
    LAllm.Free;
end;

procedure TFrm.FormCreate(Sender: TObject);
begin
    Mezo := True;
    LBev := TStringList.Create;
    LBevm := TStringList.Create;
    LKi := TStringList.Create;
    LKim := TStringList.Create;
    LAll := TStringList.Create;
    LAllm := TStringList.Create;

    LBev.LoadFromFile('bevitel.txt');
    LBevm.LoadFromFile('bevitelm.txt');
    LKi.LoadFromFile('kiadas.txt');
    LKim.LoadFromFile('kiadasm.txt');
    LAll.LoadFromFile('allapot.txt');
    LAllm.LoadFromFile('allapotm.txt');
    if FileExists('adatok.txt') then
        LoadStringGrid(DataList, 'adatok.txt');
    GridFrm;
    DataList.RowCount := DataList.RowCount + 1;
    MezokClear;
end;
// 2024. 02. 09. 21:17:44

function TFrm.GetDatum(Sor: integer): string;
var
    S: string;
    x: integer;
begin
    S := DataList.Cells[0, Sor];
    if S = '' then
        Exit;
    x := Length(S);
    while S[x] <> #32 do
        Dec(x);
    result := Copy(S, 1, x);
end;
// Updates the data of the lists
procedure TFrm.UjAdat;
begin
    case RadioGroup1.ItemIndex of
        0:
            begin
                if LBev.IndexOf(E_Megn.Text) = -1 then
                    LBev.Add(E_Megn.Text);
                if LBevm.IndexOf(E_Mertek.Text) = -1 then
                    LBevm.Add(E_Mertek.Text);
                if Mezo and (LBev.IndexOf(E_Megn.Text) = -1) then
                    Lista.Items.Add(E_Megn.Text)
                else if not Mezo and (LBevm.IndexOf(E_Mertek.Text) = -1) then
                    Lista.Items.Add(E_Mertek.Text);
            end;
        1:
            begin
                if LKi.IndexOf(E_Megn.Text) = -1 then
                    LKi.Add(E_Megn.Text);
                if LKim.IndexOf(E_Mertek.Text) = -1 then
                    LKim.Add(E_Mertek.Text);
                if Mezo and (LKi.IndexOf(E_Megn.Text) = -1) then
                    Lista.Items.Add(E_Megn.Text)
                else if not Mezo and (LKim.IndexOf(E_Mertek.Text) = -1) then
                    Lista.Items.Add(E_Mertek.Text);
            end;
        2:
            begin
                if LAll.IndexOf(E_Megn.Text) = -1 then
                    LAll.Add(E_Megn.Text);
                if LAllm.IndexOf(E_Mertek.Text) = -1 then
                    LAllm.Add(E_Mertek.Text);
                if Mezo and (LAll.IndexOf(E_Megn.Text) = -1) then
                    Lista.Items.Add(E_Megn.Text)
                else if not Mezo and (LAllm.IndexOf(E_Mertek.Text) = -1) then
                    Lista.Items.Add(E_Mertek.Text);
            end;
    end;
end;
// Sets the input fields to default
procedure TFrm.MezokClear;
begin
    E_Megn.Text := E_Megn.Hint;
    E_Megn.Font.Color := clGrayText;
    E_Mertek.Text := E_Mertek.Hint;
    E_Mertek.Font.Color := clGrayText;
end;
// Group data in StringGrid by date
procedure TFrm.Atszinez;
var
    S, Se: string;
    cl: integer;
    R: TRect;
    i: integer;
    procedure Valt;
    begin
        if cl = clCream then
            cl := clSkyBlue
        else
            cl := clCream;
    end;

begin
    try
        S := GetDatum(0);
        Se := S;
        cl := clCream;
        R := DataList.CellRect(1, 0);
        DataList.DefaultDrawing := False;
        for i := 0 to DataList.RowCount - 1 do
        begin
            S := GetDatum(i);
            if S <> Se then
            begin
                if cl = clCream then
                    cl := clSkyBlue
                else
                    cl := clCream; // Valt;
                Se := S;
            end;
            R := DataList.CellRect(1, i);
            if DataList.Cells[0, i] <> '' then
                with DataList.Canvas do
                begin
                    Brush.Color := cl;
                    FillRect(R);
                    TextOut(R.left + 5, R.Top + 2, DataList.Cells[1, i]);
                end;
        end;
    finally
        DataList.DefaultDrawing := True;
    end;
end;

procedure TFrm.GridFrm;
var
    i, j, W: integer;
    S: string;
    Wd: Array [0 .. 3] of integer;
    function Leghosszabb(var O: integer; var Szo: string): integer;
    var
        k, h: integer;
    begin
        h := 0;
        for k := 0 to DataList.RowCount - 1 do
            if Length(DataList.Cells[O, k]) > h then
            begin
                h := Length(DataList.Cells[O, k]);
                Szo := DataList.Cells[O, k];
            end;
        result := h;
    end;

begin
    for i := 1 to 3 do
    begin
        W := Leghosszabb(i, S);
        DataList.ColWidths[i] := DataList.Canvas.TextWidth('Ai') * W;
        // DataList.Canvas.TextWidth(S);
    end;
    DataList.ColWidths[0] := DataList.Canvas.TextWidth('Ai') * 20;
end;

procedure TFrm.ListaClick(Sender: TObject);
begin
    if Mezo then
        E_Megn.Text := Lista.Items[Lista.ItemIndex]
    else
        E_Mertek.Text := Lista.Items[Lista.ItemIndex];
    if Mezo then
        E_Mertek.SetFocus
    else
        Button1.SetFocus;
end;

procedure TFrm.RadioGroup1Click(Sender: TObject); // Mezo:= False;
begin
    case RadioGroup1.ItemIndex of
        0:
            Lista.Items.Assign(LBev);
        1:
            Lista.Items.Assign(LKi);
        2:
            Lista.Items.Assign(LAll);
    end;
    E_Megn.SetFocus;
end;

procedure TFrm.TabbedNotebook1Click(Sender: TObject);
begin
    Atszinez;
end;

end.
