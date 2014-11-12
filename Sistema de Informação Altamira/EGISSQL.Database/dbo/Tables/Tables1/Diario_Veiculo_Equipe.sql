CREATE TABLE [dbo].[Diario_Veiculo_Equipe] (
    [cd_diario_veiculo_equipe]  INT          NOT NULL,
    [cd_diario_veiculo]         INT          NOT NULL,
    [cd_ajudante]               INT          NOT NULL,
    [cd_mot_ocorrencia_veiculo] INT          NULL,
    [cd_advertencia]            INT          NULL,
    [nm_obs_diario_equipe]      VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Diario_Veiculo_Equipe] PRIMARY KEY CLUSTERED ([cd_diario_veiculo_equipe] ASC) WITH (FILLFACTOR = 90)
);

