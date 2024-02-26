program MekashronTest;

uses
  Vcl.Forms,
  TTFormMain in 'TTFormMain.pas' {FormMain},
  BusinessAPI in 'BusinessAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
