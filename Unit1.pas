unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.Menus, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    CounterLabel: TLabel;
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    HotKey1: THotKey;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HotKey1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    MyHotKey, Counter: Integer;
    Registered: Boolean;
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure UpdateCounterLabel;
    procedure UpdateGUI;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = MyHotKey then begin
    Counter := Counter + 1;
    UpdateCounterLabel;
  end;
end;

procedure TForm1.UpdateCounterLabel;
begin
  CounterLabel.Caption := 'Counter = ' + IntToStr(Counter);
end;

procedure TForm1.UpdateGUI;
const
  SIZE = 95;
var
  Width, Height: Integer;
begin
  Panel1.Height := Form1.Height * 10 div 100;
  Width := Panel1.Width - CheckBox1.Width;
  Height := Panel1.Height;
  HotKey1.Width := Width * SIZE div 100;
  HotKey1.Height := Height * SIZE div 100;
  HotKey1.Left := (Width - HotKey1.Width) div 2;
  HotKey1.Top := (Height - HotKey1.Height) div 2;
end;

procedure TForm1.HotKey1Change(Sender: TObject);
var
  Key: Word;
  Shift: TShiftState;
  Modifiers: UInt;
begin
  if (Registered) then
    UnRegisterHotKey(handle, MyHotKey);

  ShortCutToKey(HotKey1.HotKey, Key, Shift);
  Modifiers := MOD_NOREPEAT;
  if (hkShift in HotKey1.Modifiers) then
    Modifiers := Modifiers or MOD_SHIFT;
  if (hkCtrl in HotKey1.modifiers) then
    Modifiers := Modifiers or MOD_CONTROL;
  if (hkAlt in HotKey1.Modifiers) then
    Modifiers := Modifiers or MOD_ALT;

  MyHotKey := GlobalAddAtom('MyHotKey');
  RegisterHotKey(Handle, MyHotKey, Modifiers, Key);
  Registered := True;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  HotKey1.Enabled := CheckBox1.Checked;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MyHotKey := 0;
  Counter := 0;
  Registered := False;
  HotKey1Change(Self);
  UpdateCounterLabel;
  UpdateGUI;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  UnRegisterHotKey(Handle, MyHotKey);
end;

end.
