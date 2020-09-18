unit uDataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.SQLite, 

  uDWAbout,
  uRESTDWServerEvents, uDWDatamodule, uDWConsts, System.json,
  DataSetConverter4D.Helper, DataSetConverter4D.Impl, DataSetConverter4D, uDWJSON , uDWJSONObject,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

type
  TDataModule1 = class(TServerMethodDataModule)
    cadastro: TDWServerEvents;
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qcmd: TFDQuery;
    procedure evEventseventosReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses uMain;

procedure TDataModule1.evEventseventosReplyEventByType(
  var Params: TDWParams; var Result: string;
  const RequestType: TRequestType; var StatusCode: Integer; RequestHeader: TStringList);
  var  JSearch : TJSONValue;
       JSON    : System.Json.TJSONObject;
       SQL     : STRING;
begin
  case RequestType of
    rtGet:begin {Buscar}
            JSearch := TJSONValue.Create;
            JSearch.JsonMode := jmPureJson;
            JSearch.Encoding := Encoding;

            if Params.ItemsString['buscar'].AsString = '0' then
             BEGIN
               qcmd.close;
               qcmd.sql.Text := 'select * from Clientes';
               qcmd.Open;
             END
            else
             begin
              qcmd.close;
              qcmd.sql.Text := 'select * from Clientes where CodCliente = :CodCliente';
              qcmd.ParamByName('CodCliente').AsInteger := StrToInt(Params.ItemsString['buscar'].AsString);
              qcmd.Open;

             end;

            if qcmd.RecordCount > 0 then
             begin 
              JSearch.LoadFromDataset('',
                                      qcmd,
                                      False,
                                      jmPureJson,
                                      'dd/mm/yyyy',
                                      '.');
              result := JSearch.ToJSON;
              StatusCode := 200;
             end
            else
             begin
               Result := '{"Retorno":"Não há cadastro com este código informado!"}';
               StatusCode := 500;
             end;
          end;
    rtput:begin {Alteração}
            JSON := System.Json.TJSONObject.Create;
            JSON := System.json.TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(params.ItemsString['json'].AsString),0) as  System.json.TJSONObject;

            if Params.ItemsString['buscar'].AsString = '0' then
             BEGIN
               qcmd.close;
               qcmd.sql.Text := 'select * from Clientes';
               qcmd.Open;
             END
            else
             begin
               qcmd.close;
               qcmd.sql.Text := 'select * from Clientes where CodCliente = :Codcliente';
               qcmd.ParamByName('Codcliente').AsInteger := StrToInt(Params.ItemsString['buscar'].AsString);
               qcmd.Open;
             end;

            if qcmd.recordcount > 0 then
             try
              qcmd.RecordFromJSONObject(JSON);

              result := '{"Retorno":"Registro alterado com sucesso!"}';
              StatusCode := 200;

              except on e: Exception do
               begin
                Result := '{"Retorno" : " '+ e.Message + inttostr(StatusCode)+' "}';
                StatusCode := 501;
               end;

             end;

          end;
   rtpost:begin {Inserção}
           JSON := System.Json.TJSONObject.create;
           JSON := System.json.TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(params.ItemsString['json'].AsString),0) as  System.json.TJSONObject;


            qcmd.close;
            qcmd.sql.Text := 'select * from Clientes WHERE Codcliente = :Codcliente';
            qcmd.parambyname('Codcliente').Asinteger := StrToInt(params.ItemsString['buscar'].AsString);
            qcmd.Open;

            if qcmd.recordcount > 0 then
             BEGIN
              result := '{"Retorno":"Já possui um registro com este mesmo código!"}';
              StatusCode := 501;
             END
            else
             begin
               try
                qcmd.close;
                qcmd.sql.Text := 'select * from Clientes WHERE 1=2' ;
                qcmd.Open;
                qcmd.RecordFromJSONObject(JSON);

                result := '{"Retorno":"Registro incluso com sucesso!"}';
                StatusCode := 200;

                except on e: Exception do
                 begin
                  Result := '{"Retorno" : " '+ e.Message + inttostr(StatusCode)+' " }';
                  StatusCode := 501;
                 end;

               end;
             end;

          end;
 rtdelete:begin {Delete}
            if Params.ItemsString['buscar'].AsString = '0' then
             BEGIN
               qcmd.close;
               qcmd.sql.Text := 'select * from Clientes';
               qcmd.Open;
             END
            else
             begin
              qcmd.close;
              qcmd.sql.Text := 'select * from Clientes where CodCliente = :CodCliente';
              qcmd.ParamByName('CodCliente').AsInteger := StrToInt(Params.ItemsString['buscar'].AsString);
              qcmd.Open;

             end;

            if qcmd.RecordCount > 0 then
             begin
                try
                 qcmd.Delete;
                 result := '{"Retorno":"Registro excluído com sucesso!"}';
                 StatusCode := 200;

                  except on e: Exception do
                   begin
                    Result := '{"Retorno" : " '+ e.Message + inttostr(StatusCode)+' " }';
                    StatusCode := 501;
                   end;

                end;

             end
            ELSE
             begin
              result := '{"Retorno":"Erro ao tentar deletar!"}';
              statusCode := 200;
             end;

          end;

  end;
end;

end.
