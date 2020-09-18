unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.StdCtrls,
  cxGroupBox, uDWAbout, uRESTDWBase, dxGDIPlusClasses, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    cxGroupBox1: TcxGroupBox;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    user: TEdit;
    pass: TEdit;
    RESTServicePooler1: TRESTServicePooler;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    Function ValidaLogin: boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

 uses uDataModule;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if ValidaLogin then
  begin
    RESTServicePooler1.Active := not RESTServicePooler1.Active;

   if RESTServicePooler1.Active then
    begin
     Caption := 'ON-LINE';
     Button1.Caption := 'STOP SERVER';
    end
   else
    begin
     Caption := 'OFF-LINE';
     Button1.Caption := 'START SERVER';
    end;

  end
 else
 ShowMessage('Não foi possível fazer login!');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 RESTServicePooler1.ServerMethodClass := TDataModule1;
end;


function TForm1.ValidaLogin: boolean;
begin
 result := True;
 if RESTServicePooler1.ServerParams.UserName <> user.Text then result := false;
 if RESTServicePooler1.ServerParams.Password <> pass.Text then result := false;
end;

end.
