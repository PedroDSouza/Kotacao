unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ZConnection, ZDataset;

type

  { TForm3 }

  TForm3 = class(TForm)
    btGravar: TBitBtn;
    edCaminhoBanco: TEdit;
    Image1: TImage;
    Label1: TLabel;
    PanelConfiguracoes: TPanel;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    ZQuery1CAMINHOBANCO: TStringField;
    procedure btGravarClick(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.btGravarClick(Sender: TObject);
var caminho: String;
begin


   if (edCaminhoBanco.Text = null) or (edCaminhoBanco.Text = '') then
    begin

       ShowMessage('O caminho não pode ficar vazio!');

    end else
    begin
      //  ZQuery1.SQL.Text := 'UPDATE OR INSERT INTO CONFIGURACAO(ID, CAMINHOBANCO) VALUES (NULL,''' + caminho + ''')';
      //  ZQuery1.ExecSQL;

    end;
   try
   //  ZQuery1.SQL.Text := 'UPDATE OR INSERT INTO CONFIGURACAO(ID, CAMINHOBANCO) VALUES (NULL,''' + caminho + ''')';
    // ZQuery1.ExecSQL;
   finally
     ShowMessage('Alterado com sucesso');
   end;



end;


end.

