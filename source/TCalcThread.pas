unit TCalcThread;

interface

uses
  Classes;

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
begin
  { Place thread code here }
end;

end.
