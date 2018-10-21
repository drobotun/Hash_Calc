unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Buttons,
  Clipbrd, MD5Hash, CRC32Hash, GOST2012Hash, GOST94Hash, ComCtrls;

type
  TMainForm = class(TForm)
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
    GOST94Check: TCheckBox;
    CRC32Check: TCheckBox;
    ChekThread: TMenuItem;
    Logo_3: TLabel;
    StatusBar: TStatusBar;
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
    procedure ChekThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure FormInit;
procedure FormEnable;

var
  MainForm : TMainForm;
  ThreadPriority : TThreadPriority;

implementation

uses CalcThread, About, ChoiseThread;

var
      CalcThread : TCalcThread;

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
      StatusBar.Panels.Items[1].Text := '';
      StatusBar.Panels.Items[3].Text := '';
      StatusBar.Panels.Items[5].Text := '';
    end;
end;

procedure FormEnable;
begin
  with MainForm do
    begin
      MD5Check.Enabled := true;
      GOST256Check.Enabled := true;
      GOST512Check.Enabled := true;
      GOST94Check.Enabled := true;
      CRC32Check.Enabled := true;
      FileEdit.Enabled := true;
      GOST256Edit.Enabled := true;
      GOST512Edit.Enabled := true;
      GOST94Edit.Enabled := true;
      CRC32Edit.Enabled := true;
      MD5Edit.Enabled := true;
      FileButton.Enabled := true;
      FileMenu.Enabled := true;
      AboutMenu.Enabled := true;
    end;
end;

procedure FormDisable;
begin
  with MainForm do
    begin
      MD5Check.Enabled := false;
      GOST256Check.Enabled := false;
      GOST512Check.Enabled := false;
      GOST94Check.Enabled := false;
      CRC32Check.Enabled := false;
      FileEdit.Enabled := false;
      GOST256Edit.Enabled := false;
      GOST512Edit.Enabled := false;
      GOST94Edit.Enabled := false;
      CRC32Edit.Enabled := false;
      MD5Edit.Enabled := false;
      FileButton.Enabled := false;
      FileMenu.Enabled := false;
      AboutMenu.Enabled := false;
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
          CalcThread := TCalcThread.Create(true);
          CalcThread.Priority := ThreadPriority;
          CalcThread.Resume;
          FileEdit.Text := OpenFile.FileName;
          CalcThread.FreeOnTerminate := true;
        end;
      end
    else MessageBox(0,'Do not specify the hash algorithm',
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

procedure TMainForm.ChekThreadClick(Sender: TObject);
begin
  ChoiseThreadForm.ShowModal;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ThreadPriority := tpNormal;
end;

end.
