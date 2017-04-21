program HashCalc;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  About in 'About.pas' {AboutForm},
  MD5Hash in 'MD5Hash.pas',
  CRC32Hash in 'CRC32Hash.pas',
  GOST94Hash in 'GOST94Hash.pas',
  GOST2012Hash in 'GOST2012Hash.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
