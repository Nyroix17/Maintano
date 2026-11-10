unit module2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, DB, Forms, Controls, StdCtrls, DBGrids, ComCtrls,
  ActnList;

type

  { TFrameModule2 }

  TFrameModule2 = class(TFrame)
    ActionAccueil: TAction;
    ActionInsererEntretien: TAction;
    ActionInsererPDC: TAction;
    ActionInsererPDC1: TAction;
    ActionInsererVoiture: TAction;
    ActionModifierPDC: TAction;
    ActionPDC: TAction;
    ActionQuitter: TAction;
    ActionRefreshPDC: TAction;
    ActionStatistique: TAction;
    ActionSupprimePDC: TAction;
    ActionVehicule: TAction;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    SQLQuery1: TSQLQuery;

  private

  public

  end;

implementation
uses dialogs, dlg_formulaire1, Unit1;

{$R *.lfm}

{ TFrameModule2 }

end.

