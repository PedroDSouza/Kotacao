unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ZConnection, ZDataset, fphttpclient, opensslsockets, DB, DateUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    LabelAtualizado: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListaMaiorValor1: TListBox;
    ListaMoedas: TListBox;
    ListaPreco: TListBox;
    ListaMaiorValor: TListBox;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelMaiorValor: TPanel;
    QueryCotacaoValor: TCurrencyField;
    ZConnection1: TZConnection;
    QueryCotacao: TZQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Resposta: String;
  ValorDolarUniv: Currency;
  DataDolarUniv: String;

implementation


procedure FazerRequisicaoHTTP;
var
  HTTPClient: TFPHTTPClient;
  Response: TStringStream;
begin

  HTTPClient := TFPHTTPClient.Create(nil);
  Response := TStringStream.Create('');

  try
    HTTPClient.Get('https://economia.awesomeapi.com.br/last/USD-BRL', Response);  //Método GET para pegar os dados do endereço e armazená-los na variável
    Resposta := UTF8ToString(Response.DataString);      //Armazena a resposta da API acima na variável; converti de UTF8ToString pra evitar erros

  except
    on E: Exception do
    begin
      ShowMessage('Erro na requisição HTTP: ' + E.Message);
    end;
  end;

  Response.Free;
  HTTPClient.Free;

end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button5Click(Sender: TObject);
begin

  Panel2.Visible := False;

end;

procedure TForm1.Button1Click(Sender: TObject);
var valordolar: Currency;
    datadolar:  String;
begin

    valordolar := ValorDolarUniv;
    datadolar  := Copy( (StringReplace(DataDolarUniv, '-', '.', []) ), 1, 10);

    QueryCotacao.Connection := ZConnection1;

    try

    QueryCotacao.SQL.Text := 'UPDATE OR INSERT INTO COTACAO(MOEDA, DATA, VALOR, VALORCOMPRA) VALUES(''U$'', '+ '''' + datadolar + ''''+ ' , ' + StringReplace((FloatToStr(valordolar)), ',', '.', []) + ' , ' + StringReplace((FloatToStr(valordolar)), ',', '.', []) + ' ) MATCHING(MOEDA, DATA)';
    QueryCotacao.ExecSQL;

    finally
      ShowMessage('Cotação inserida!');
      //ShowMessage('Fechando o Programa');
      //Halt;
    end;


end;

procedure TForm1.Button2Click(Sender: TObject);
var ResponseLocal: String;
    ResponseData: String;
    ResponseMaiorValor: String;
    ValorStr: String;
    StrData: String;
    ValorDolar: Currency;

    data: TDateTime;
    horario: TTime;

begin

   FazerRequisicaoHTTP;
   ResponseLocal := Resposta;


   data := Now;
   horario := TimeOf(data);

   ShowMessage('Valores atualizados! Data: ' + DateToStr(data) + ' às ' + TimeToStr(horario));
   LabelAtualizado.Caption := 'Atualizado em Tempo Real às: ' + TimeToStr(horario);

   Memo1.Lines.Text := IntToStr(Pos('"high"',ResponseLocal));  //Pega a posição de onde começa o "high" (maior preço da cotação diária)
   ValorStr := Copy(ResponseLocal, (Pos('"high"',ResponseLocal) + 8), 6);
   ValorDolar := StrToFloat(StringReplace(ValorStr, '.', ',', []));


   ListaPreco.Items.Clear;
   ListaPreco.Items.Add(FloatToStr(ValorDolar));
   ValorDolarUniv :=  ValorDolar;

   ResponseMaiorValor := Resposta;
   ListaMaiorValor.Items.Clear;
   ResponseMaiorValor := Copy(Resposta, (Pos('"low"', Resposta)+7), 5);
   ListaMaiorValor.Items.Add('Dólar: ' + ResponseMaiorValor);



end;

procedure TForm1.Button4Click(Sender: TObject);
begin

  ShowMessage('SISTEMA EM DESENVOLVIMENTO! -Pedro de Souza');

end;

procedure TForm1.Button6Click(Sender: TObject);
begin

  Panel2.Visible := True;

end;

procedure TForm1.FormActivate(Sender: TObject);
var ResponseLocal: String;
    ResponseData: String;
    ResponseMaiorValor: String;
    ValorStr: String;
    StrData: String;
    ValorDolar: Currency;
    data: TDateTime;
    horario: TTime;

begin

   FazerRequisicaoHTTP;

   data := Now;
   horario := TimeOf(data);


   LabelAtualizado.Caption := 'Atualizado em Tempo Real às: ' + TimeToStr(horario);


   ResponseLocal := Resposta;
   Memo1.Lines.Text := IntToStr(Pos('"high"',ResponseLocal));  //Pega a posição de onde começa o "high" (maior preço da cotação diária)
   ValorStr := Copy(ResponseLocal, (Pos('"high"',ResponseLocal) + 8), 6);
   ValorDolar := StrToFloat(StringReplace(ValorStr, '.', ',', []));


   ResponseData := Resposta;
   Label2.Caption := IntToStr(Pos('"create_date"', ResponseData));  //Pega a posição de onde começa o "create_date" (data da cotação)
   StrData :=  IntToStr(Pos('"create_date"', ResponseData)+5);
   Label2.Caption := Copy(ResponseData, (Pos('"create_date"', ResponseData)+15), 18);
   StrData :=  StringReplace( Copy(ResponseData, (Pos('"create_date"', ResponseData)+15), 18) , '-', '.', []);

   ResponseMaiorValor := Resposta;
   ListaMaiorValor.Items.Clear;
   ResponseMaiorValor := Copy(ResponseData, (Pos('"low"', ResponseData)+7), 5);
   ListaMaiorValor.Items.Add('Dólar: ' + ResponseMaiorValor);



   ListaPreco.Items.Add(FloatToStr(ValorDolar));
   ValorDolarUniv :=  ValorDolar;
   DataDolarUniv  := StrData;


end;

procedure TForm1.FormCreate(Sender: TObject);                       //variável auxiliar apenas
begin

  //ShowMessage('Aviso: é necessário ter internet para que os valores atualizados apareçam');




end;



end.

