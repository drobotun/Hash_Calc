unit ChoiseThread;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TChoiseThreadForm = class(TForm)
    ThreadImage: TImage;
    ThreadLogo: TLabel;
    ThreadOKButton: TButton;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    procedure ThreadOKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChoiseThreadForm: TChoiseThreadForm;

implementation

uses
  Main;

{$R *.dfm}

procedure TChoiseThreadForm.ThreadOKButtonClick(Sender: TObject);
begin
  if RadioButton1.Checked then ThreadPriority := tpLowest;
  if RadioButton2.Checked then ThreadPriority := tpLower;
  if RadioButton3.Checked then ThreadPriority := tpNormal;
  if RadioButton4.Checked then ThreadPriority := tpHigher;
  if RadioButton5.Checked then ThreadPriority := tpHighest;
  if RadioButton6.Checked then ThreadPriority := tpTimeCritical;
  Close;
end;

end.
