unit CalcThread;

interface

uses
  Windows, Classes, SysUtils, Main, MD5Hash, CRC32Hash, GOST2012Hash, GOST94Hash;

type
  TCalcThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TCalcThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TCalcThread }

procedure TCalcThread.Execute;
var
  BeginTime,
  CalcTime,
  EndTime : TDateTime;
begin
  BeginTime := Time;
  MainForm.StatusBar.Panels.Items[1].Text := TimeToStr(BeginTime);
  try
    with MainForm do
    begin
      if MD5Check.Checked then
        MD5Edit.Text := MD5DigestToStr(MD5File(OpenFile.FileName));
      if GOST256Check.Checked then
        GOST256Edit.Text := GOST2012_HashFileToString(OpenFile.FileName, 256);
      if GOST512Check.Checked then
        GOST512Edit.Text := GOST2012_HashFileToString(OpenFile.FileName, 512);
      if GOST94Check.Checked then
        GOST94Edit.Text :=  GOST94DigestToStr(GOST94File(OpenFile.FileName));
      if CRC32Check.Checked then
        CRC32Edit.Text := IntToHex(CRC32File(OpenFile.FileName), 8);
    end;
  except
    MessageBox(0,'Ошибка чтения файла', 'Hash Calc',
                     MB_OK or MB_ICONWARNING);
    FormInit;
  end;
  FormEnable;
  EndTime := Time;
  CalcTime := EndTime - BeginTime;
  MainForm.StatusBar.Panels.Items[3].Text := TimeToStr(EndTime);
  MainForm.StatusBar.Panels.Items[5].Text := TimeToStr(CalcTime);
end;

end.
