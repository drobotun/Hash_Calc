unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TAboutForm = class(TForm)
    AboutOKButton: TButton;
    AboutImage: TImage;
    Bevel1: TBevel;
    AboutLogo_1: TLabel;
    AboutLogo_2: TLabel;
    AboutLogo_3: TLabel;
    CopyrightLabel_2: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure AboutOKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.AboutOKButtonClick(Sender: TObject);
begin
  Close;
end;

end.
