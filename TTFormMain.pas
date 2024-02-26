unit TTFormMain;
//https://play.google.com/store/apps/details?id=com.embarcadero.alle_center&hl=en_US&gl=US&pli=1
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Soap.InvokeRegistry, System.Net.URLClient, Soap.Rio, Soap.SOAPHTTPClient,
  Vcl.StdCtrls, Vcl.Buttons,IniFiles, BusinessAPI, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids,
  InvokeRegistry, Dialogs, DB, Rio, SOAPHTTPClient, StdCtrls, Grids, DBGrids,
  Buttons, Controls, ExtCtrls, ComCtrls, Classes;

type
  TFormMain = class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    SheetView: TTabSheet;
    SheetEntityAdd: TTabSheet;
    SheetTelemarketingAdd: TTabSheet;
    SheetINI: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    ol_EntityId: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ol_UserName: TEdit;
    Label3: TLabel;
    ol_Password: TEdit;
    Label4: TLabel;
    BusinessId: TEdit;
    Label5: TLabel;
    Employee_EntityId: TEdit;
    Label6: TLabel;
    CategoryID: TEdit;
    Label7: TLabel;
    Email: TEdit;
    Label8: TLabel;
    Password: TEdit;
    Label9: TLabel;
    FirstName: TEdit;
    Label10: TLabel;
    LastName: TEdit;
    Label11: TLabel;
    Mobile: TEdit;
    Label12: TLabel;
    CountryISO: TComboBox;
    Label13: TLabel;
    affiliate_entityID: TEdit;
    Panel5: TPanel;
    sbExecute: TSpeedButton;
    Label14: TLabel;
    MemoEnityADD: TMemo;
    HTTPRIO1: THTTPRIO;
    Panel3: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label28: TLabel;
    ol_EntityId1: TEdit;
    ol_UserName1: TEdit;
    ol_Password1: TEdit;
    campaignID1: TEdit;
    EntityIds1: TEdit;
    Panel6: TPanel;
    sbExecute1: TSpeedButton;
    MemoTelemarketingAdd: TMemo;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel7: TPanel;
    Panel8: TPanel;
    CheckBoxTema: TCheckBox;
    OpenDialog1: TOpenDialog;
    Panel9: TPanel;
    Label20: TLabel;
    EditVendorMYSQL: TEdit;
    Label21: TLabel;
    UserNameMYSQL: TEdit;
    Label22: TLabel;
    PasswordMYSQL: TEdit;
    Label23: TLabel;
    ServerMYSQL: TEdit;
    Label24: TLabel;
    PortMYSQL: TEdit;
    Label25: TLabel;
    DataBaseMYSQL: TEdit;
    sbOpenDialog: TSpeedButton;
    Panel10: TPanel;
    sbSaveAndExecute: TSpeedButton;
    sbDefaultMYSQL: TSpeedButton;
    sbOnlySave: TSpeedButton;
    cbLoginPromtMYSQL: TCheckBox;
    Label26: TLabel;
    Panel11: TPanel;
    Label27: TLabel;
    procedure sbExecuteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbExecute1Click(Sender: TObject);
    procedure CheckBoxTemaClick(Sender: TObject);
    procedure sbOpenDialogClick(Sender: TObject);
    procedure sbOnlySaveClick(Sender: TObject);
    procedure sbDefaultMYSQLClick(Sender: TObject);
    procedure sbSaveAndExecuteClick(Sender: TObject);
    procedure CountryISOClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FDQuery1BeforeScroll(DataSet: TDataSet);
    procedure FDQuery1AfterOpen(DataSet: TDataSet);
  private
    { Private declarations }

    procedure LoadFromIni();
    procedure SaveToIni();
    procedure LoadDBConnectionFromINI();
    procedure SaveDBConnectionToINI();
    procedure ExecuteConnection();

    procedure setWidtToColGrid();
    function getFileNameIni(): String;
    function getFileNameIniDB(): String;
    function getIntFromStr(const S:String): integer;
    function getNextSubStr(var S,S1:String): boolean;


  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}


//-----------------------------------------------------------------------------
procedure TFormMain.FormCreate(Sender: TObject);
begin
LoadFromIni();
LoadDBConnectionFromINI();
ExecuteConnection();
setWidtToColGrid();

end;
procedure TFormMain.FormShow(Sender: TObject);
begin
CountryISO.SelText:='';
CountryISO.SelLength:=0;

end;

//-----------------------------------------------------------------------------

function TFormMain.getNextSubStr(var S,S1:String): boolean;
//Вычленение подстроки S1 из строки S
//Вход
//Стркоа S  типа
//S:='1,2,3,4,5,6,7,8..."
//Разделитель может быть
//','-pапятая
//';'-точка с запятой
//'-'-тире
//'.'-точка
//'#'-решетка
//'@'-обезъяна
//'*'-звездочка
//'|'-вертикальная черта

//Выход:
//Строка
//S:='2,3,4,5,6,7,8..."
//S1:='1';
var
ipos: Integer;
begin
S1:='';
S:=S.Trim();
result:=False;
if S.IsEmpty then EXIT;
ipos:=AnsiPos(',',S);
if ipos<=0 then  ipos:=AnsiPos(';',S);
if ipos<=0 then  ipos:=AnsiPos('-',S);
if ipos<=0 then  ipos:=AnsiPos('.',S);
if ipos<=0 then  ipos:=AnsiPos('#',S);
if ipos<=0 then  ipos:=AnsiPos('@',S);
if ipos<=0 then  ipos:=AnsiPos('*',S);
if ipos<=0 then  ipos:=AnsiPos('|',S);
if ipos<=0 then  Exit;
S1:=Trim(S.SubString(0,ipos-1));
S:=Trim(S.SubString(ipos,S.Length));
Result:=True;








end;
//-------------------------------------------------------------------------
procedure TFormMain.CheckBoxTemaClick(Sender: TObject);
begin
if CheckBoxTema.Checked then
begin
  Color:=StringToColor('$002E2E2E');
  Font.Color:=clWhite;

end

else
begin
  Color:=clBtnFace;
  Font.Color:=clBlack;


end;

        DBGrid1.Color:=Color;
  DBGrid1.Font.Color:=Font.Color;//clBlack;//clBlack;

end;
//-----------------------------------------------------------------------------
procedure TFormMain.FDQuery1AfterOpen(DataSet: TDataSet);
begin
StatusBar1.Panels.Items[1].Text:=IntToStr(FDQuery1.RecordCount);
StatusBar1.Panels.Items[0].Text:=IntToStr(FDQuery1.RecNo);
end;

procedure TFormMain.FDQuery1BeforeScroll(DataSet: TDataSet);
begin

StatusBar1.Panels.Items[0].Text:=IntToStr(FDQuery1.RecNo);
end;
//-----------------------------------------------------------------------------
procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 SaveToIni();
end;
//-------------------------------------------------------------------------

procedure TFormMain.SaveToIni();
var
I:Integer;
FileName:String;
ini: TIniFile;
begin

        FileName:=getFileNameIni();
        try
        ini:= TIniFile.Create(FileName);

          for I := 0 to ComponentCount-1 do
           begin
                if AnsiPos('MYSQL',Components[I].Name) > 0 then continue;

                if Components[I].ClassNameIs('TEdit') then
                begin
                 ini.WriteString('TEdit',Components[I].Name,(Components[I] AS TEdit).Text );
                end;

                if Components[I].ClassNameIs('TComboBox') then
                begin
                 ini.WriteString('TComboBox',Components[I].Name,(Components[I] AS TComboBox).Text );
                end;

                if Components[I].ClassNameIs('TMemo') then
                begin
                ini.WriteString('TMemo',Components[I].Name,'' );
                 ini.WriteString('TMemo',Components[I].Name,(Components[I] AS TMemo).Text );
                end;

                if Components[I].ClassNameIs('TCheckBox') then
                begin
                   ini.WriteBool('TCheckBox',Components[I].Name,(Components[I] AS TCheckBox).Checked );
                end;


          end;


        finally
        FreeAndNil(ini);
        end;

end;
// ---------------------------------------------------------------------------
procedure TFormMain.LoadFromIni();
var
I:Integer;
FileName:String;
ini: TIniFile;

begin
        FileName:=getFileNameIni();
        if NOT FileExists(FileName) then EXIT;
        try
        ini:= TIniFile.Create(FileName);

        for I := 0 to ComponentCount-1 do
            begin
                 if AnsiPos('MYSQL',Components[I].Name) > 0 then continue;

              if Components[I].ClassNameIs('TEdit') then
              begin
              (Components[I] AS TEdit).Text:=
               ini.ReadString('TEdit',Components[I].Name,(Components[I] AS TEdit).Text );
              end;

              if Components[I].ClassNameIs('TComboBox') then
              begin
              (Components[I] AS TComboBox).Text:=
               ini.ReadString('TComboBox',Components[I].Name,(Components[I] AS TComboBox).Text );
              end;

              if Components[I].ClassNameIs('TMemo') then
              begin

              (Components[I] AS TMemo).Clear;
              (Components[I] AS TMemo).Lines.Add(
               ini.ReadString('TMemo',Components[I].Name,(Components[I] AS TMemo).Text ));
              end;


              if Components[I].ClassNameIs('TCheckBox') then
              begin
              (Components[I] AS TCheckBox).Checked:= ini.ReadBool('TCheckBox',Components[I].Name,(Components[I] AS TCheckBox).Checked );
              end;


          end;

        CheckBoxTemaClick(CheckBoxTema);

        finally
        FreeAndNil(ini);
        end;

end;
// ---------------------------------------------------------------------------

procedure TFormMain.LoadDBConnectionFromINI();
var
I:Integer;
FileName:String;
ini: TIniFile;

begin
        FileName:= getFileNameIniDB();

        if NOT FileExists(FileName) then EXIT;

        try
        ini:= TIniFile.Create(FileName);

        EditVendorMYSQL.Text:=
        ini.ReadString('MY SQL','EditVendorMYSQL'
        ,EditVendorMYSQL.Text );


        UserNameMYSQL.Text:=
        ini.ReadString('MY SQL','UserNameMYSQL' ,UserNameMYSQL.Text);

        PasswordMYSQL.Text:=
        ini.ReadString('MY SQL','PasswordMYSQL' ,PasswordMYSQL.Text);

        ServerMYSQL.Text:=
        ini.ReadString('MY SQL','ServerMYSQL' ,ServerMYSQL.Text);

        PortMYSQL.Text:=
        ini.ReadString('MY SQL','PortMYSQL' ,PortMYSQL.Text);

        DataBaseMYSQL.Text:=
        ini.ReadString('MY SQL','DataBaseMYSQL' ,DataBaseMYSQL.Text);

        cbLoginPromtMYSQL.Checked:=
        ini.ReadBool('MY SQL','cbLoginPromtMYSQL' ,cbLoginPromtMYSQL.Checked);


        finally
        FreeAndNil(ini);
        end;


end;
// ---------------------------------------------------------------------------
procedure TFormMain.SaveDBConnectionToINI();
var
I:Integer;
FileName:String;
ini: TIniFile;

begin
        FileName:= getFileNameIniDB();
        ini:= TIniFile.Create(FileName);
        try
        ini.WriteString('MY SQL','EditVendorMYSQL' ,EditVendorMYSQL.Text);
        ini.WriteString('MY SQL','UserNameMYSQL' ,UserNameMYSQL.Text);
        ini.WriteString('MY SQL','PasswordMYSQL' ,PasswordMYSQL.Text);
        ini.WriteString('MY SQL','ServerMYSQL' ,ServerMYSQL.Text);
        ini.WriteString('MY SQL','PortMYSQL' ,PortMYSQL.Text);
        ini.WriteString('MY SQL','DataBaseMYSQL' ,DataBaseMYSQL.Text);
        ini.WriteBool('MY SQL','cbLoginPromtMYSQL' ,cbLoginPromtMYSQL.Checked);
        finally
        FreeAndNil(ini);
        end;


end;
// ---------------------------------------------------------------------------



function TFormMain.getFileNameIni(): String;
var path:String;
begin
    path:=ExtractFilePath(Application.ExeName)+'set\\';
    if NOT DirectoryExists(path) then ForceDirectories(path);
    if NOT DirectoryExists(path) then path:=ExtractFilePath(Application.ExeName);
    Result:=path+ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
end;
//-----------------------------------------------------------------------------
function TFormMain.getFileNameIniDB(): String;
var path:String;
begin
    path:=ExtractFilePath(Application.ExeName)+'set\\DB\\';
    if NOT DirectoryExists(path) then ForceDirectories(path);
    if NOT DirectoryExists(path) then path:=ExtractFilePath(Application.ExeName);
    Result:=path+ChangeFileExt(ExtractFileName(Application.ExeName),'_DB.ini');
end;
//-----------------------------------------------------------------------------

procedure TFormMain.setWidtToColGrid();
var
i: Integer;
begin

if NOT FDQuery1.Active then EXIT;

for i := 0 to DBGrid1.Columns.Count-1 do
begin

  if DBGrid1.Columns.Items[i].Width <= 100 then continue;
  DBGrid1.Columns.Items[i].Width:=100;

end;




end;
//-----------------------------------------------------------------------------
procedure TFormMain.sbDefaultMYSQLClick(Sender: TObject);
begin
      EditVendorMYSQL.Text:='C:\\Mekashron\\libmysql.dll';
      UserNameMYSQL.Text:='root';
      PasswordMYSQL.Text:='';
      ServerMYSQL.Text:='127.0.0.1';
      PortMYSQL.Text:='3306';
      DataBaseMYSQL.Text:='MekashronBusiness';
      cbLoginPromtMYSQL.Checked:=False;

end;
//-----------------------------------------------------------------------------
procedure TFormMain.sbOnlySaveClick(Sender: TObject);
begin
SaveDBConnectionToINI();
end;
//-----------------------------------------------------------------------------
procedure TFormMain.sbOpenDialogClick(Sender: TObject);
begin
if NOT OpenDialog1.Execute then EXIT;
EditVendorMYSQL.Text:=OpenDialog1.FileName;

end;
//-----------------------------------------------------------------------------
procedure TFormMain.sbSaveAndExecuteClick(Sender: TObject);
begin
SaveDBConnectionToINI();
ExecuteConnection();
end;
//-----------------------------------------------------------------------------
procedure TFormMain.CountryISOClick(Sender: TObject);
var
tmpS,tmpS1:String;
begin
tmpS:=CountryISO.Text;
tmpS1:=CountryISO.Text;
if( AnsiPos('-',tmpS1) >0)then getNextSubStr(tmpS,tmpS1);
CountryISO.Hint:=tmpS1;

end;

Procedure TFormMain.ExecuteConnection();
begin
FDQuery1.Close;
FDConnection1.Connected:=False;
FDPhysMySQLDriverLink1.VendorLib:=EditVendorMYSQL.Text;
FDConnection1.Params.Clear;
FDConnection1.Params.Add('Database='+DataBaseMYSQL.Text);
FDConnection1.Params.Add('User_Name='+UserNameMYSQL.Text);
FDConnection1.Params.Add('Server='+ServerMYSQL.Text);
FDConnection1.Params.Add('DriverID=MySQL');
FDConnection1.Params.Add('Port='+PortMYSQL.Text);
FDConnection1.LoginPrompt:=cbLoginPromtMYSQL.Checked;
FDConnection1.Connected:=True;
FDQuery1.Open;

end;

function TFormMain.getIntFromStr(const S:String): integer;
//Вход строка, типа '1234'
//Выход: число       1234
//или
//если строка пустая 0

begin
  Result:=0;
	if (Trim(S).IsEmpty())	then	exit;
	try
      Result := StrToInt(S);
      except
      Result:=0;
    end;
end;
// ---------------------------------------------------------------------------

procedure TFormMain.sbExecute1Click(Sender: TObject);
var
 EntityIds: ArrayOfInt;
 I:Integer;
 tmpS,S1: String;
 bOldActive:Boolean;
begin
Screen.Cursor:=crAppStart;

         tmpS:=EntityIds1.Text;
        I:=0;

while getNextSubStr(tmpS,S1) do
begin
SetLength(EntityIds, I+1);
EntityIds[I]:=getIntFromStr(S1);
//MemoTelemarketingAdd.Lines.Add(S1);
Inc(I);
end;

bOldActive:=FDQuery1.Active;
FDQuery1.Close;

 MemoTelemarketingAdd.Text:=(HTTPRIO1 as IBusinessAPI).
  Telemarketing_add
    (getIntFromStr(ol_EntityId1.Text)            //const ol_EntityId: Integer
    , Trim(ol_UserName1.Text)                           //const ol_UserName: string
    , Trim(ol_Password1.Text)                           // const ol_Password: string
    , getIntFromStr(campaignID1.Text)                 //const campaignID: Integer
    ,EntityIds);

FDQuery1.Active:=bOldActive;
Screen.Cursor:=crDefault;

end;
//-----------------------------------------------------------------------------
procedure TFormMain.sbExecuteClick(Sender: TObject);
var
bOldActive:Boolean;
tmpS,tmpS1:String;

begin
Screen.Cursor:=crAppStart;
bOldActive:=FDQuery1.Active;
FDQuery1.Close;

tmpS:=CountryISO.Text;
tmpS1:=CountryISO.Text;
if( AnsiPos('-',tmpS1) >0)then getNextSubStr(tmpS,tmpS1);
CountryISO.Hint:=tmpS1;



 MemoEnityADD.Text:=(HTTPRIO1 as IBusinessAPI).
  Entity_Add
    (getIntFromStr(ol_EntityId.Text)            //const ol_EntityId: Integer
    , Trim(ol_UserName.Text)                           //const ol_UserName: string
    , Trim(ol_Password.Text)                           // const ol_Password: string
    , getIntFromStr(BusinessId.Text)                 //const BusinessId: Integer
    , getIntFromStr(Employee_EntityId.Text)             //const Employee_EntityId: Integer
    , getIntFromStr(CategoryID.Text)                 //const CategoryID: Integer
    , Trim(Email.Text)                                      //'ciut-it@mail.ru'//const Email: string
    , Trim(Password.Text)// '12345678'//const Password: string
    , Trim(FirstName.Text)// 'andrea'//const FirstName: string
    , Trim(LastName.Text)// 'tima'//const LastName: string
    , Trim(Mobile.Text)//9262185000'//const Mobile: string
    , Trim(tmpS1)//'RU'//const CountryISO: string
    , getIntFromStr(affiliate_entityID.Text) ////const affiliate_entityID: Integer: string; stdcall;
    );

FDQuery1.Active:=bOldActive;
Screen.Cursor:=crDefault;
end;
//-----------------------------------------------------------------------------
end.
