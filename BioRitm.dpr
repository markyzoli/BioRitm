program BioRitm;

uses
    Vcl.Forms,
    Bio in 'Bio.pas' {Frm};

{$R *.res}

begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.CreateForm(TFrm, Frm);
    Application.Run;

end.
