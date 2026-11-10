unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn, DB, Forms, Controls, Graphics, Dialogs,
  Menus, ComCtrls, ActnList, ExtCtrls, StdCtrls, Variants, FileUtil, DateUtils;

type
  { TForm1 }

  TForm1 = class(TForm)
    ActionStatistique: TAction;
    ActionPDC: TAction;
    ActionVehicule: TAction;
    ActionInsererPDC: TAction;
    ActionInsererEntretien: TAction;
    ActionAccueil: TAction;
    ActionInsererVoiture: TAction;
    ActionQuitter: TAction;
    ActionList1: TActionList;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem5: TMenuItem;
    PanelModule: TPanel;
    Splitter1: TSplitter;
    SQLite3Connection1: TSQLite3Connection;
    SQLTransaction1: TSQLTransaction;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    pdc: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    Vehicule: TToolButton;
    procedure ActionAccueilExecute(Sender: TObject);
    procedure ActionInsererEntretienExecute(Sender: TObject);
    procedure ActionInsererPDCExecute(Sender: TObject);
    procedure ActionInsererVoitureExecute(Sender: TObject);
    procedure ActionPDCExecute(Sender: TObject);
    procedure ActionQuitterExecute(Sender: TObject);
    procedure ActionStatistiqueExecute(Sender: TObject);
    procedure ActionVehiculeExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
    module : TFrame;
    v : integer;
    pdc2 : string;
    charge: string;
    debut: string;
    fin: string;
    sta: string;
    ev: integer;
    com: string;
  end;


var
  Form1: TForm1;

implementation
uses module0, module1, module2, module3, dlg_formulaire1, dlg_formulaire2, dlg_formulaire3;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.FormShow(Sender: TObject);
begin
     SQLite3Connection1.Connected := True;

     // IMPORTANT
     SQLite3Connection1.ExecuteDirect(
       'PRAGMA foreign_keys = ON;'
     );

     SQLite3Connection1.ExecuteDirect(
       'PRAGMA busy_timeout = 5000;'
     );

     SQLTransaction1.Active := True;

     ActionAccueilExecute(self);
end;

procedure TForm1.ActionQuitterExecute(Sender: TObject);
begin
     Close;
end;

procedure TForm1.ActionStatistiqueExecute(Sender: TObject);
begin
     if Assigned(module) then
        module.Free;

     module := TFrameModule2.Create(PanelModule);
     module.Parent := PanelModule;
     module.Align := alClient;

     // 3. LA CORRECTION EST LÀ : On allume la requête de CE module à chaque visite !
     TFrameModule2(module).SQLQuery1.Open;
end;

procedure TForm1.ActionVehiculeExecute(Sender: TObject);
begin
     if Assigned(module) then
        module.Free;

     module := TFrameModule1.Create(PanelModule);
     module.Parent := PanelModule;
     module.Align := alClient;

     // 3. LA CORRECTION EST LÀ : On allume la requête de CE module à chaque visite !
     TFrameModule1(module).SQLQuery1.Open;
end;

procedure TForm1.ActionAccueilExecute(Sender: TObject);
begin
     if Assigned(module) then
        module.Free;

     module := TFrameModule0.Create(PanelModule);
     module.Parent := PanelModule;
     module.Align := alClient;

     // 3. LA CORRECTION EST LÀ : On allume la requête de CE module à chaque visite !
     TFrameModule0(module).SQLQuery1.Open;
end;

procedure TForm1.ActionInsererEntretienExecute(Sender: TObject);
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
    ActionAccueilExecute(self);
  end;
end;

procedure TForm1.ActionInsererPDCExecute(Sender: TObject);
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
    ActionPDCExecute(self);
  end;

end;

procedure TForm1.ActionInsererVoitureExecute(Sender: TObject);
var
  dlg : TDlgFormulaire2;
  r   : Integer;

  km      : Double;
  poids   : Double;

  SourceFile : String;
  DestFile   : String;
  NomPhoto   : String;
begin
  dlg := TDlgFormulaire2.Create(Self);

  try

    repeat
    r := dlg.ShowModal;

    if r <> mrOK then
      Break;

    // =========================
    // Vérifications
    // =========================

    if (Trim(dlg.Immat.Text) = '') or (Trim(dlg.kilometrage.Text) = '') or (Trim(dlg.Photo.Text) = '') or (Trim(dlg.Poids.Text) = '') then
    begin
      ShowMessage('Champ obligatoire vide.');
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

        if Trim(dlg.Immat.Text) = '' then
        begin
          ShowMessage('Immatriculation obligatoire.');
          Exit;
        end;

        if not TryStrToFloat(Trim(dlg.Kilometrage.Text), km) then
        begin
          ShowMessage('Kilométrage invalide.');
          Exit;
        end;

        if not TryStrToFloat(Trim(dlg.Poids.Text), poids) then
        begin
          ShowMessage('Poids invalide.');
          Exit;
        end;

        // =========================
        // Gestion photo
        // =========================

        if Trim(dlg.Photo.Text) = '' then
        begin
          ShowMessage('Veuillez sélectionner une photo.');
          Exit;
        end;

        SourceFile := Trim(dlg.Photo.Text);

        // Vérifie que le fichier existe
        if not FileExists(SourceFile) then
        begin
          ShowMessage('Le fichier photo est introuvable.');
          Exit;
        end;

        // Création dossier photos
        if not DirectoryExists('photos') then
          CreateDir('photos');

        // Nom du fichier uniquement
        NomPhoto := ExtractFileName(SourceFile);

        // Destination
        DestFile := 'photos\' + NomPhoto;

        // Copie image
        CopyFile(SourceFile, DestFile);

        // =========================
        // Requête SQL
        // =========================

        dlg.SQLQuery1.Close;

        dlg.SQLQuery1.SQL.Text :=
          'INSERT INTO vehicule (' +
          'immat, kilometrage, marque, modele, couleur, poids, photo' +
          ') VALUES (' +
          ':Pimmat, :Pkm, :Pmarque, :Pmodele, :Pcouleur, :Ppoids, :Pphoto' +
          ')';

        // =========================
        // Paramètres
        // =========================

        dlg.SQLQuery1.ParamByName('Pimmat').AsString :=
          Trim(dlg.Immat.Text);

        dlg.SQLQuery1.ParamByName('Pkm').AsFloat :=
          km;

        dlg.SQLQuery1.ParamByName('Pmarque').AsString :=
          Trim(dlg.Marque.Text);

        dlg.SQLQuery1.ParamByName('Pmodele').AsString :=
          Trim(dlg.Modele.Text);

        dlg.SQLQuery1.ParamByName('Pcouleur').AsString :=
          Trim(dlg.Couleur.Text);

        dlg.SQLQuery1.ParamByName('Ppoids').AsFloat :=
          poids;

        // On stocke seulement le nom
        dlg.SQLQuery1.ParamByName('Pphoto').AsString :=
          NomPhoto;

        // =========================
        // Exécution
        // =========================

        dlg.SQLQuery1.ExecSQL;

        Form1.SQLTransaction1.Commit;

        ShowMessage('Véhicule ajouté avec succès.');

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
        ActionInsererVoitureExecute(self);
    end

    else
      ShowMessage('Insertion annulée.');
  finally
    dlg.Free;
    ActionVehiculeExecute(self);
  end;
end;

procedure TForm1.ActionPDCExecute(Sender: TObject);
begin
     if Assigned(module) then
        module.Free;

     module := TFrameModule3.Create(PanelModule);
     module.Parent := PanelModule;
     module.Align := alClient;

     // 3. LA CORRECTION EST LÀ : On allume la requête de CE module à chaque visite !
     TFrameModule3(module).SQLQuery1.Open;
end;


end.

