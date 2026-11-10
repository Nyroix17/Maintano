unit module3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, DBGrids, ComCtrls, ActnList, Dialogs, dlg_formulaire6,
  Unit1;

type

  { TFrameModule3 }

  TFrameModule3 = class(TFrame)
    ActionAccueil: TAction;
    ActionInsererEntretien: TAction;
    ActionInsererPDC: TAction;
    ActionList1: TActionList;
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
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure ActionInsererPDCExecute(Sender: TObject);
    procedure ActionModifierPDCExecute(Sender: TObject);
    procedure ActionRefreshPDCExecute(Sender: TObject);
    procedure ActionSupprimePDCExecute(Sender: TObject);
  private
         procedure ChargerPDCDansDialog(dlg : TDlgFormulaire6);
  public

  end;

implementation
uses dlg_formulaire3;
{$R *.lfm}

{ TFrameModule3 }

procedure TFrameModule3.ActionRefreshPDCExecute(Sender: TObject);
begin
     SQLQuery1.Close;
     SQLQuery1.Open;
end;

procedure TFrameModule3.ChargerPDCDansDialog(
  dlg : TDlgFormulaire6
);
begin
  dlg.idPDC :=
    DataSource1.DataSet.FieldByName('id').AsInteger;

  dlg.nom.Text :=
    DataSource1.DataSet.FieldByName('nom').AsString;

  dlg.duree.Text :=
    DataSource1.DataSet.FieldByName('duree_moyenne').AsString;

  dlg.description.Lines.Text :=
    DataSource1.DataSet.FieldByName('description').AsString;
end;

procedure TFrameModule3.ActionSupprimePDCExecute(Sender: TObject);
var
  idPDC : Integer;
begin
  idPDC :=
    DataSource1.DataSet.FieldByName('id').AsInteger;

  if MessageDlg(
    'Supprimer ce point de contrôle ?',
    mtConfirmation,
    [mbYes, mbNo],
    0
  ) = mrNo then
    Exit;

  try
    // IMPORTANT
    SQLQuery1.Close;

    SQLQuery1.SQL.Text :=
      'DELETE FROM point_de_controle WHERE id = :id';

    SQLQuery1.ParamByName('id').AsInteger :=
      idPDC;

    // EXECUTION
    SQLQuery1.ExecSQL;

    // COMMIT
    Form1.SQLTransaction1.Commit;

    ShowMessage('Point de contrôle supprimé.');

  except
    on E: Exception do
    begin
      Form1.SQLTransaction1.Rollback;

      ShowMessage(
        'Impossible de supprimer ce point de contrôle car il est utilisé dans un entretien.'
      );
      SQLQuery1.Close;

      SQLQuery1.SQL.Text :=
        'SELECT * FROM point_de_controle';

      SQLQuery1.Open;
      Exit;
    end;
  end;

  // RECHARGEMENT DU GRID
  SQLQuery1.Close;

  SQLQuery1.SQL.Text :=
    'SELECT * FROM point_de_controle';

  SQLQuery1.Open;
end;

procedure TFrameModule3.ActionInsererPDCExecute(Sender: TObject);
var
  dlg : TDlgFormulaire3;
  r   : Integer;

  nom      : string;
  temps   : integer;
  description : string;
begin
  dlg := TDlgFormulaire3.Create(Self);

  try

    repeat
    r := dlg.ShowModal;

    if r <> mrOK then
      Break;

    // =========================
    // Vérifications
    // =========================

    if (Trim(dlg.nom.Text) = '') then
    begin
      ShowMessage('Nom point de contrôle manquant.');
      Continue;
    end;

    // si tout est bon
    Break;

  until False;

    if r = mrOK then
    begin
      try
        // =========================
        // Vérifications
        // =========================

        if Trim(dlg.nom.Text) = '' then
        begin
          ShowMessage('Nom du point de contrôle obligatoire.');
          Exit;
        end;

        if not TryStrToInt(Trim(dlg.duree.Text), temps) then
        begin
          ShowMessage('Durée invalide.');
          Exit;
        end;


        // =========================
        // Requête SQL
        // =========================

        dlg.SQLQuery1.Close;

        dlg.SQLQuery1.SQL.Text :=
          'INSERT INTO point_de_controle (' +
          'nom, duree_moyenne, description' +
          ') VALUES (' +
          ':Pnom, :Ptemps, :Pdescription' +
          ')';

        // =========================
        // Paramètres
        // =========================

        dlg.SQLQuery1.ParamByName('Pnom').AsString :=
          Trim(dlg.nom.Text);

        dlg.SQLQuery1.ParamByName('Ptemps').AsInteger :=
          temps;

        dlg.SQLQuery1.ParamByName('Pdescription').AsString :=
          Trim(dlg.Description.Text);

        // =========================
        // Exécution
        // =========================

        dlg.SQLQuery1.ExecSQL;

        Form1.SQLTransaction1.Commit;

        ShowMessage('Point de contrôle ajouté avec succès.');

      except
        on E: Exception do
        begin
          Form1.SQLTransaction1.Rollback;

          ShowMessage(
            'Erreur lors de l''insertion :' + #13#10 +
            E.Message
          );
        end;
      end;
    end
    else if r = mrRetry then begin
        ActionInsererPDCExecute(self);
    end

    else
      ShowMessage('Insertion annulée.');
  finally
    dlg.Free;
    ActionRefreshPDCExecute(self);
  end;
end;

procedure TFrameModule3.ActionModifierPDCExecute(Sender: TObject);
var
  dlg : TDlgFormulaire6;
begin
  dlg := TDlgFormulaire6.Create(Self);

  try
    // =====================================
    // PRE-REMPLISSAGE
    // =====================================

    ChargerPDCDansDialog(dlg);

    // =====================================
    // BOUCLE DIALOG
    // =====================================

    repeat

      case dlg.ShowModal of

        // =====================================
        // OK = UPDATE
        // =====================================

        mrOK:
        begin
          try
            SQLQuery1.Close;

            SQLQuery1.SQL.Text :=
              'UPDATE point_de_controle SET ' +
              'nom = :nom, ' +
              'duree_moyenne = :duree, ' +
              'description = :description ' +
              'WHERE id = :id';

            // =====================================
            // PARAMETRES
            // =====================================

            SQLQuery1.ParamByName('nom').AsString :=
              Trim(dlg.nom.Text);

            SQLQuery1.ParamByName('duree').AsInteger :=
              StrToInt(dlg.duree.Text);

            SQLQuery1.ParamByName('description').AsString :=
              Trim(dlg.description.Lines.Text);

            SQLQuery1.ParamByName('id').AsInteger :=
              dlg.idPDC;

            // =====================================
            // EXECUTION
            // =====================================

            SQLQuery1.ExecSQL;

            Form1.SQLTransaction1.Commit;

            ShowMessage(
              'Point de contrôle modifié.'
            );

            Break;

          except
            on E: Exception do
            begin
              Form1.SQLTransaction1.Rollback;

              ShowMessage(
                'Erreur : ' + E.Message
              );
            end;
          end;
        end;

        // =====================================
        // RESET
        // =====================================

        mrRetry:
        begin
          ChargerPDCDansDialog(dlg);
        end;

        // =====================================
        // ANNULER
        // =====================================

        mrCancel:
        begin
          Break;
        end;

      end;

    until False;

    // =====================================
    // REFRESH GRID
    // =====================================

    SQLQuery1.Close;

    SQLQuery1.SQL.Text :=
      'SELECT * FROM point_de_controle';

    SQLQuery1.Open;

  finally
    dlg.Free;
  end;
end;

end.

