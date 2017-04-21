unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Buttons,
  Clipbrd, MD5Hash, CRC32Hash, GOST2012Hash, GOST94Hash;

type
  TMainForm = class(TForm)
    ExitButton: TButton;
    LogoImage: TImage;
    Logo_1: TLabel;
    Logo_2: TLabel;
    FileMenu: TLabel;
    AboutMenu: TLabel;
    Bevel1: TBevel;
    FilePopupMenu: TPopupMenu;
    ChooseFileMenu: TMenuItem;
    N1: TMenuItem;
    ExitMenu: TMenuItem;
    OpenFile: TOpenDialog;
    FileEdit: TEdit;
    FileButton: TButton;
    FileLabel: TLabel;
    MD5Edit: TEdit;
    MD5Label: TLabel;
    GOST256Edit: TEdit;
    GOST256Label: TLabel;
    CRC32Edit: TEdit;
    CRC32Label: TLabel;
    MD5CopyButton: TSpeedButton;
    GOST256CopyButton: TSpeedButton;
    CRC32CopyButton: TSpeedButton;
    GOST512Label: TLabel;
    GOST512Edit: TEdit;
    GOST512CopyButton: TSpeedButton;
    GOST94Label: TLabel;
    GOST94Edit: TEdit;
    GOST94CopyButton: TSpeedButton;
    MD5Check: TCheckBox;
    GOST256Check: TCheckBox;
    GOST512Check: TCheckBox;
    Gost94Check: TCheckBox;
    CRC32Check: TCheckBox;
    procedure ExitButtonClick(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure ExitMenuClick(Sender: TObject);
    procedure ChooseFileMenuClick(Sender: TObject);
    procedure FileButtonClick(Sender: TObject);
    procedure AboutMenuClick(Sender: TObject);
    procedure MD5CopyButtonClick(Sender: TObject);
    procedure CRC32CopyButtonClick(Sender: TObject);
    procedure GOST94CopyButtonClick(Sender: TObject);
    procedure GOST256CopyButtonClick(Sender: TObject);
    procedure GOST512CopyButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses About;

{$R *.dfm}

procedure FormInit;
begin
  with MainForm do
    begin
      FileEdit.Text := '';
      GOST256Edit.Text := '';
      GOST512Edit.Text := '';
      GOST94Edit.Text := '';
      CRC32Edit.Text := '';
      MD5Edit.Text := '';
    end;
end;

procedure FormEnable;
begin
  with MainForm do
    begin
      FileEdit.Enabled := true;
      GOST256Edit.Enabled := true;
      GOST512Edit.Enabled := true;
      GOST94Edit.Enabled := true;
      CRC32Edit.Enabled := true;
      MD5Edit.Enabled := true;
      GOST256Label.Enabled := true;
      GOST512Label.Enabled := true;
      GOST94Label.Enabled := true;
      CRC32Label.Enabled := true;
      MD5Label.Enabled := true;
      Filelabel.Enabled := true;
      FileButton.Enabled := true;
      FileMenu.Enabled := true;
      AboutMenu.Enabled := true;
      ExitButton.Enabled := true;
    end;
end;

procedure FormDisable;
begin
  with MainForm do
    begin
      FileEdit.Enabled := false;
      GOST256Edit.Enabled := false;
      GOST512Edit.Enabled := false;
      GOST94Edit.Enabled := false;
      CRC32Edit.Enabled := false;
      MD5Edit.Enabled := false;
      GOST256Label.Enabled := false;
      GOST512Label.Enabled := false;
      GOST94Label.Enabled := false;
      CRC32Label.Enabled := false;
      MD5Label.Enabled := false;
      Filelabel.Enabled := false;
      FileButton.Enabled := false;
      FileMenu.Enabled := false;
      AboutMenu.Enabled := false;
      ExitButton.Enabled := false;
    end;
end;

procedure FileOpen;
begin
  FormInit;
  FormDisable;
  with MainForm do
  if MD5Check.Checked or GOST94Check.Checked or CRC32Check.Checked or
       GOST256Check.Checked or GOST512Check.Checked then
    begin
      if OpenFile.Execute then
        begin
          FormInit;
          try
            if MD5Check.Checked then
              MD5Edit.Text := MD5DigestToStr(MD5File(OpenFile.FileName));
            if GOST256Check.Checked then
              GOST256Edit.Text := GOST2012_HashFileToString(OpenFile.FileName, 256);;
            if GOST512Check.Checked then
              GOST512Edit.Text := GOST2012_HashFileToString(OpenFile.FileName, 512);
            if GOST94Check.Checked then
              GOST94Edit.Text :=  GOST94DigestToStr(GOST94File(OpenFile.FileName));
            if CRC32Check.Checked then
              CRC32Edit.Text := IntToHex(CRC32File(OpenFile.FileName), 8);
            FileEdit.Text := OpenFile.FileName;
          except
            MessageBox(0,'Ошибка чтения файла', 'Hash Calc',
                     MB_OK or MB_ICONWARNING);
          end;
        end;
      end
    else MessageBox(0,'Не задан алгоритм контрольного суммирования',
                   'Hash Calc',
                   MB_OK or MB_ICONWARNING);
  FormEnable;
end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FileMenuClick(Sender: TObject);
begin
  FilePopupMenu.Popup(MainForm.Left + FileMenu.Left, MainForm.Top +
  Filemenu.Top +40);
end;

procedure TMainForm.ExitMenuClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.ChooseFileMenuClick(Sender: TObject);
begin
  FileOpen;
end;

procedure TMainForm.FileButtonClick(Sender: TObject);
begin
  FileOpen;
end;

procedure TMainForm.AboutMenuClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.MD5CopyButtonClick(Sender: TObject);
begin
  ClipBoard.AsText := MD5Edit.Text;
end;

procedure TMainForm.CRC32CopyButtonClick(Sender: TObject);
begin
  ClipBoard.AsText := CRC32Edit.Text;
end;

procedure TMainForm.GOST94CopyButtonClick(Sender: TObject);
begin
  ClipBoard.AsText := GOST94Edit.Text;
end;

procedure TMainForm.GOST256CopyButtonClick(Sender: TObject);
begin
  ClipBoard.AsText := GOST256Edit.Text;
end;

procedure TMainForm.GOST512CopyButtonClick(Sender: TObject);
begin
  ClipBoard.AsText := GOST512Edit.Text;
end;

end.
