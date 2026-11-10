unit module0;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, Forms, Controls, DBGrids, ExtCtrls, StdCtrls,
  Dialogs, ComCtrls, ActnList, FileUtil, DateUtils;

type

  { TFrameModule0 }

  TFrameModule0 = class(TFrame)
    ActionModifierEntretien: TAction;
    ActionSupprimerEntretien: TAction;
    ActionRefreshEntretien: TAction;
    ActionInsererEntretien: TAction;
    ActionList1: TActionList;
    ComboBoxPDC: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PanelPDC: TPanel;
    PanelStatut: TPanel;
    PanelFiltre: TPanel;
    PanelDate: TPanel;
    RadioJour: TRadioButton;
    RadioSemaine: TRadioButton;
    RadioMois: TRadioButton;
    RadioAttente: TRadioButton;
    RadioCours: TRadioButton;
    RadioTermine: TRadioButton;
    RadioDateAucun: TRadioButton;
    RadioStatutAucun: TRadioButton;
    RadioGroupDate: TRadioGroup;
    RadioGroupDate1: TRadioGroup;
    RadioGroupDate2: TRadioGroup;
    Splitter1: TSplitter;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure ActionInsererEntretienExecute(Sender: TObject);
    procedure ActionModifierEntretienExecute(Sender: TObject);
    procedure ActionRefreshEntretienExecute(Sender: TObject);
    procedure ActionSupprimerEntretienExecute(Sender: TObject);
    procedure AppliquerFiltres;
    procedure RadioJourChange(Sender: TObject);
    procedure RadioSemaineChange(Sender: TObject);
    procedure RadioMoisChange(Sender: TObject);
    procedure RadioDateAucunChange(Sender: TObject);
    procedure RadioAttenteChange(Sender: TObject);
    procedure RadioCoursChange(Sender: TObject);
    procedure RadioTermineChange(Sender: TObject);
    procedure RadioStatutAucunChange(Sender: TObject);
    procedure ComboBoxPDCChange(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
  private
    procedure chargerPDC;
    procedure OuvrirEntretien;
  public
    v : integer;
    pdc2 : string;
    charge: string;
    debut: string;
    fin: string;
    sta: string;
    ev: integer;
    com: string;
  end;

implementation
uses dlg_formulaire1, dlg_formulaire4, Unit1;
{$R *.lfm}

procedure TFrameModule0.AppliquerFiltres;
var
  SQLTexte : String;
begin
  SQLTexte :=
  'SELECT ' +
  'entretien.numero_entretien, ' +
  'entretien.id_vehicule, ' +

  'vehicule.immat, ' +
  'vehicule.marque, ' +
  'vehicule.modele, ' +

  'point_de_controle.nom AS nom_pdc, ' +

  'entretien.date_arrivee, ' +
  'entretien.date_prise_en_charge, ' +
  'entretien.date_depart, ' +

  'entretien.statut, ' +
  'entretien.evaluation, ' +
  'entretien.commentaire ' +

  'FROM entretien ' +

  'INNER JOIN vehicule ' +
  'ON vehicule.id = entretien.id_vehicule ' +

  'INNER JOIN point_de_controle ' +
  'ON point_de_controle.id = entretien.id_pdc ' +

  'WHERE 1=1';

  // =========================
  // FILTRE DATE
  // =========================

  if RadioJour.Checked then
    SQLTexte := SQLTexte +
      ' AND substr(date_arrivee,1,10) = date(''now'')';

  if RadioSemaine.Checked then
    SQLTexte := SQLTexte +
      ' AND substr(date_arrivee,1,10) >= date(''now'', ''-7 day'')';

  if RadioMois.Checked then
    SQLTexte := SQLTexte +
      ' AND substr(date_arrivee,1,10) >= date(''now'', ''-1 month'')';

  // =========================
  // FILTRE STATUT
  // =========================

  if RadioAttente.Checked then
    SQLTexte := SQLTexte +
      ' AND statut = ''En attente''';

  if RadioCours.Checked then
    SQLTexte := SQLTexte +
      ' AND statut = ''En cours''';

  if RadioTermine.Checked then
    SQLTexte := SQLTexte +
      ' AND statut = ''Terminé''';

  // =========================
  // FILTRE PDC
  // =========================

  if Trim(ComboBoxPDC.Text) <> '' then
    SQLTexte := SQLTexte +
      ' AND point_de_controle.nom = ' +
      QuotedStr(ComboBoxPDC.Text);

  // =========================
  // TRI
  // =========================

  SQLTexte := SQLTexte +
    ' ORDER BY date_arrivee DESC';

  // =========================
  // EXECUTION
  // =========================

  SQLQuery1.Close;
  SQLQuery1.SQL.Text := SQLTexte;
  SQLQuery1.Open;

  DBGrid1.Columns.ColumnByFieldName('id_vehicule').Visible := False;
end;

procedure TFrameModule0.OuvrirEntretien;
var
  dlg : TDlgFormulaire4;
  idVehicule : Integer;
begin
  if DataSource1.DataSet.IsEmpty then
  begin
    ShowMessage(
      'Aucun entretien sélectionné.'
    );
    Exit;
  end;

  dlg := TDlgFormulaire4.Create(Self);

  try
    // =====================================
    // INFOS ENTRETIEN
    // =====================================

    dlg.NumeroEntretien.Text :=
      DataSource1.DataSet.FieldByName(
        'numero_entretien'
      ).AsString;

    dlg.DateArriver.Text :=
      DataSource1.DataSet.FieldByName(
        'date_arrivee'
      ).AsString;

    dlg.DateCharge.Text :=
      DataSource1.DataSet.FieldByName(
        'date_prise_en_charge'
      ).AsString;

    dlg.DateDepart.Text :=
      DataSource1.DataSet.FieldByName(
        'date_depart'
      ).AsString;

    dlg.Statut.Text :=
      DataSource1.DataSet.FieldByName(
        'statut'
      ).AsString;

    dlg.Evaluation.Text :=
      DataSource1.DataSet.FieldByName(
        'evaluation'
      ).AsString;

    dlg.description.Lines.Text :=
      DataSource1.DataSet.FieldByName(
        'commentaire'
      ).AsString;

    // =====================================
    // RECUP ID VEHICULE
    // =====================================

    idVehicule :=
      DataSource1.DataSet.FieldByName(
        'id_vehicule'
      ).AsInteger;

    // =====================================
    // REQUETE VEHICULE
    // =====================================

    SQLQuery2.Close;

    SQLQuery2.SQL.Text :=
      'SELECT * FROM vehicule ' +
      'WHERE id = :id';

    SQLQuery2.ParamByName('id').AsInteger :=
      idVehicule;

    SQLQuery2.Open;

    // =====================================
    // INFOS VEHICULE
    // =====================================

    dlg.Immat.Text :=
      SQLQuery2.FieldByName(
        'immat'
      ).AsString;

    dlg.NomPhoto :=
      SQLQuery2.FieldByName(
        'photo'
      ).AsString;

    dlg.ChargerImage(
      dlg.NomPhoto
    );

    // =====================================
    // TACHES
    // =====================================

    if dlg.Statut.Text = 'En attente' then
      dlg.effectuer.Lines.Text :=
        dlg.description.Lines.Text;

    if dlg.Statut.Text = 'En cours' then
      dlg.cours.Lines.Text :=
        dlg.description.Lines.Text;

    if dlg.Statut.Text = 'Terminé' then
      dlg.termine.Lines.Text :=
        dlg.description.Lines.Text;

    // =====================================
    // OUVERTURE
    // =====================================

    dlg.ShowModal;

  finally
    dlg.Free;
  end;
end;

procedure TFrameModule0.ActionRefreshEntretienExecute(Sender: TObject);
begin
     SQLQuery1.Close;
     SQLQuery1.Open;
end;

procedure TFrameModule0.ActionSupprimerEntretienExecute(Sender: TObject);
begin
     OuvrirEntretien;
end;

procedure TFrameModule0.ActionInsererEntretienExecute(Sender: TObject);
var
  dlg : TDlgFormulaire1;
  r   : Integer;

  sqlChamps : String;
  sqlValues : String;
begin
  dlg := TDlgFormulaire1.Create(Self);

  try
    dlg.SQLQuery1.Active := True;
    dlg.SQLQuery2.Active := True;

    repeat
    r := dlg.ShowModal;

    if r <> mrOK then
      Break;

    // =========================
    // Vérifications
    // =========================

    if (Trim(dlg.id_vehicule.Text) = '') OR (Trim(dlg.id_pdc.Text) = '') then
    begin
      ShowMessage('ID manquant.');
      Continue;
    end;

    // si tout est bon
    Break;

  until False;

    if r = mrOK then
    begin
      try
        // =========================
        // Vérification ID véhicule
        // =========================

        if not TryStrToInt(Trim(dlg.id_vehicule.Text), v) then
        begin
          ShowMessage('L''ID véhicule doit être un nombre.');
          Exit;
        end;

        // =========================
        // Vérification ID PDC
        // =========================

        if Trim(dlg.id_pdc.Text) = '' then
        begin
          ShowMessage('Le point de contrôle est obligatoire.');
          Exit;
        end;

        // =========================
        // Evaluation
        // =========================

        if not TryStrToInt(Trim(dlg.eval.Text), ev) then
          ev := 1;

        // =========================
        // Dates automatiques
        // =========================

        if Trim(dlg.Statut.Text) = 'En cours' then
        begin
          // prise en charge auto
          if Trim(dlg.DateCharge.Text) = '' then
            dlg.DateCharge.Text :=
              FormatDateTime('yyyy-mm-dd', Date);

          // arrivée auto
          if Trim(dlg.DateArriver.Text) = '' then
            dlg.DateArriver.Text :=
              FormatDateTime('yyyy-mm-dd', Date);
        end;

        if Trim(dlg.Statut.Text) = 'Terminé' then
        begin
          // arrivée auto
          if Trim(dlg.DateArriver.Text) = '' then
            dlg.DateArriver.Text :=
              FormatDateTime('yyyy-mm-dd', Date);

          // prise en charge auto
          if Trim(dlg.DateCharge.Text) = '' then
            dlg.DateCharge.Text :=
              FormatDateTime('yyyy-mm-dd', Date);

          // départ NON automatique
        end;

        // =========================
        // Champs obligatoires
        // =========================

        sqlChamps :=
          'id_vehicule, id_pdc, evaluation, commentaire';

        sqlValues :=
          ':Pv, :Ppdc2, :Pev, :Pcom';

        // =========================
        // Date prise en charge
        // =========================

        if Trim(dlg.DateCharge.Text) <> '' then
        begin
          sqlChamps := sqlChamps + ', date_prise_en_charge';
          sqlValues := sqlValues + ', :Pcharge';
        end;

        // =========================
        // Date arrivée
        // =========================

        if Trim(dlg.DateArriver.Text) <> '' then
        begin
          sqlChamps := sqlChamps + ', date_arrivee';
          sqlValues := sqlValues + ', :Pdebut';
        end;

        // =========================
        // Date départ
        // =========================

        if Trim(dlg.DateDep.Text) <> '' then
        begin
          sqlChamps := sqlChamps + ', date_depart';
          sqlValues := sqlValues + ', :Pfin';
        end;

        // =========================
        // Statut
        // =========================

        if Trim(dlg.Statut.Text) <> '' then
        begin
          sqlChamps := sqlChamps + ', statut';
          sqlValues := sqlValues + ', :Psta';
        end;

        // =========================
        // Création requête SQL
        // =========================

        dlg.SQLQuery1.Close;

        dlg.SQLQuery1.SQL.Text :=
          'INSERT INTO entretien (' + sqlChamps + ') ' +
          'VALUES (' + sqlValues + ')';

        // =========================
        // Paramètres obligatoires
        // =========================

        dlg.SQLQuery1.ParamByName('Pv').AsInteger := v;

        dlg.SQLQuery1.ParamByName('Ppdc2').AsString :=
          Trim(dlg.id_pdc.Text);

        dlg.SQLQuery1.ParamByName('Pev').AsInteger := ev;

        dlg.SQLQuery1.ParamByName('Pcom').AsString :=
          Trim(dlg.commentaire.Lines.Text);

        // =========================
        // Date prise en charge
        // =========================

        if Trim(dlg.DateCharge.Text) <> '' then
          dlg.SQLQuery1.ParamByName('Pcharge').AsString :=
            Trim(dlg.DateCharge.Text);

        // =========================
        // Date arrivée
        // =========================

        if Trim(dlg.DateArriver.Text) <> '' then
          dlg.SQLQuery1.ParamByName('Pdebut').AsString :=
            Trim(dlg.DateArriver.Text);

        // =========================
        // Date départ
        // =========================

        if Trim(dlg.DateDep.Text) <> '' then
          dlg.SQLQuery1.ParamByName('Pfin').AsString :=
            Trim(dlg.DateDep.Text);

        // =========================
        // Statut
        // =========================

        if Trim(dlg.Statut.Text) <> '' then
          dlg.SQLQuery1.ParamByName('Psta').AsString :=
            Trim(dlg.Statut.Text);

        // =========================
        // Exécution
        // =========================

        dlg.SQLQuery1.ExecSQL;

        Form1.SQLTransaction1.Commit;

        ShowMessage('Insertion réussie !');

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
        ActionInsererEntretienExecute(self);
    end

    else
      ShowMessage('Insertion annulée.');

  finally
    dlg.Free;
    ActionRefreshEntretienExecute(self);
  end;
end;

procedure TFrameModule0.ActionModifierEntretienExecute(Sender: TObject);
begin
     OuvrirEntretien;
end;

procedure TFrameModule0.DBGrid1CellClick(Column: TColumn);
var
  dlg : TDlgFormulaire4;
  idVehicule : Integer;
begin
  dlg := TDlgFormulaire4.Create(Self);

  try
    // =========================
    // DONNEES ENTRETIEN
    // =========================

    dlg.NumeroEntretien.Text :=
      DataSource1.DataSet.FieldByName('numero_entretien').AsString;

    dlg.DateArriver.Text :=
      DataSource1.DataSet.FieldByName('date_arrivee').AsString;

    dlg.DateCharge.Text :=
      DataSource1.DataSet.FieldByName('date_prise_en_charge').AsString;

    dlg.DateDepart.Text :=
      DataSource1.DataSet.FieldByName('date_depart').AsString;

    dlg.Statut.Text :=
      DataSource1.DataSet.FieldByName('statut').AsString;

    dlg.Evaluation.Text :=
      DataSource1.DataSet.FieldByName('evaluation').AsString;

    dlg.Description.Lines.Text :=
      DataSource1.DataSet.FieldByName('commentaire').AsString;

    // =========================
    // ID VEHICULE
    // =========================

    idVehicule :=
      DataSource1.DataSet.FieldByName('id_vehicule').AsInteger;

    // =========================
    // REQUETE VEHICULE
    // =========================

    dlg.SQLQuery1.Close;

    dlg.SQLQuery1.SQL.Text :=
      'SELECT * FROM vehicule WHERE id = :Pid';

    dlg.SQLQuery1.ParamByName('Pid').AsInteger :=
      idVehicule;

    dlg.SQLQuery1.Open;

    // =========================
    // INFOS VEHICULE
    // =========================

    dlg.Immat.Text :=
      dlg.SQLQuery1.FieldByName('immat').AsString;

    dlg.ChargerImage(
      dlg.SQLQuery1.FieldByName('photo').AsString
    );

    dlg.ChargerTaches;

    // =========================
    // OUVERTURE DIALOGUE
    // =========================

    case dlg.ShowModal of

      // =========================
      // MODIFICATION
      // =========================

      mrOK:
      begin
        dlg.SQLQueryAction.Close;

        dlg.SQLQueryAction.SQL.Text :=
          'UPDATE entretien SET ' +
          'date_arrivee = :PdateA, ' +
          'date_prise_en_charge = :PdateC, ' +
          'date_depart = :PdateD, ' +
          'statut = :Pstatut, ' +
          'evaluation = :Peval, ' +
          'commentaire = :Pcom ' +
          'WHERE numero_entretien = :Pid';

        // Dates
        dlg.SQLQueryAction.ParamByName('PdateA').AsDate :=
          StrToDate(dlg.DateArriver.Text);

        dlg.SQLQueryAction.ParamByName('PdateC').AsDate :=
          StrToDate(dlg.DateCharge.Text);

        dlg.SQLQueryAction.ParamByName('PdateD').AsDate :=
          StrToDate(dlg.DateDepart.Text);

        // Autres champs
        dlg.SQLQueryAction.ParamByName('Pstatut').AsString :=
          dlg.Statut.Text;

        dlg.SQLQueryAction.ParamByName('Peval').AsInteger :=
          StrToIntDef(dlg.Evaluation.Text, 1);

        dlg.SQLQueryAction.ParamByName('Pcom').AsString :=
          dlg.Description.Lines.Text;

        dlg.SQLQueryAction.ParamByName('Pid').AsInteger :=
          StrToInt(dlg.NumeroEntretien.Text);

        // Execution
        dlg.SQLQueryAction.ExecSQL;

        // Validation
        Form1.SQLTransaction1.CommitRetaining;

        // Refresh
        AppliquerFiltres;
      end;

      // =========================
      // SUPPRESSION
      // =========================

      mrAbort:
      begin
        dlg.SQLQueryAction.Close;

        dlg.SQLQueryAction.SQL.Text :=
          'DELETE FROM entretien ' +
          'WHERE numero_entretien = :Pid';

        dlg.SQLQueryAction.ParamByName('Pid').AsInteger :=
          StrToInt(dlg.NumeroEntretien.Text);

        if (dlg.DateCharge.Text <> '') and (StrToDate(dlg.DateCharge.Text) < StrToDate(dlg.DateArriver.Text)) then
        begin
          ShowMessage('La date de prise en charge ne peut pas être avant la date d''arrivée.');
          Exit;
        end;

        if (dlg.DateDepart.Text <> '') and
           (StrToDate(dlg.DateDepart.Text) <
            StrToDate(dlg.DateArriver.Text)) then
        begin
          ShowMessage('La date de départ ne peut pas être avant la date d''arrivée.');
          Exit;
        end;

        if (dlg.DateDepart.Text <> '') and
           (dlg.DateCharge.Text <> '') and
           (StrToDate(dlg.DateDepart.Text) <
            StrToDate(dlg.DateCharge.Text)) then
        begin
          ShowMessage('La date de départ ne peut pas être avant la prise en charge.');
          Exit;
        end;

        dlg.SQLQueryAction.ExecSQL;

        Form1.SQLTransaction1.CommitRetaining;

        AppliquerFiltres;
      end;

      mrRetry:
      begin
           DBGrid1CellClick(column);
      end;

    end;

  finally
    dlg.Free;
  end;
end;

procedure TFrameModule0.ChargerPDC;
begin
  ComboBoxPDC.Items.Clear;

  // option vide
  ComboBoxPDC.Items.Add('');

  // ou :
  // ComboBoxPDC.Items.Add('Aucun');

  SQLQuery2.Close;
  SQLQuery2.SQL.Text :=
    'SELECT nom FROM point_de_controle ORDER BY nom';
  SQLQuery2.Open;

  while not SQLQuery2.EOF do
  begin
    ComboBoxPDC.Items.Add(
      SQLQuery2.FieldByName('nom').AsString
    );

    SQLQuery2.Next;
  end;

  ComboBoxPDC.ItemIndex := 0;
end;

procedure TFrameModule0.RadioJourChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.RadioSemaineChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.RadioMoisChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.RadioDateAucunChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.RadioAttenteChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.RadioCoursChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.RadioTermineChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.RadioStatutAucunChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.ComboBoxPDCChange(Sender: TObject);
begin
  AppliquerFiltres;
end;

procedure TFrameModule0.FrameEnter(Sender: TObject);
begin
  ChargerPDC;
end;

end.

