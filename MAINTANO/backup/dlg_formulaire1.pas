unit dlg_formulaire1;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, DBGrids, ComCtrls, CheckLst, EditBtn, ExtendedNotebook,
  Unit1;

type

  { TDlgFormulaire1 }

  TDlgFormulaire1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Statut: TComboBox;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DateCharge: TEdit;
    DateDep: TEdit;
    DateArriver: TEdit;
    eval: TEdit;
    id_vehicule: TEdit;
    id_pdc: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    commentaire: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid2CellClick(Column: TColumn);
  private

  public

  end;

var
  DlgFormulaire1: TDlgFormulaire1;

implementation
{$R *.lfm}

{ TDlgFormulaire1 }

procedure TDlgFormulaire1.DBGrid1CellClick(Column: TColumn);
begin
  if DBGrid1.DataSource.DataSet.Active then
    id_vehicule.Text := DBGrid1.DataSource.DataSet.FieldByName('id').AsString;
end;

procedure TDlgFormulaire1.DBGrid2CellClick(Column: TColumn);
begin
  if DBGrid1.DataSource.DataSet.Active then
    id_pdc.Text := DBGrid2.DataSource.DataSet.FieldByName('id').AsString;
end;

end.

