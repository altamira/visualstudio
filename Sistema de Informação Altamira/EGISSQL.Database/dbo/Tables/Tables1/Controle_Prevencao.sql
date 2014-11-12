CREATE TABLE [dbo].[Controle_Prevencao] (
    [cd_controle_prevencao] INT          NOT NULL,
    [nm_controle_prevencao] VARCHAR (50) NULL,
    [ds_controle_prevencao] TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Controle_Prevencao] PRIMARY KEY CLUSTERED ([cd_controle_prevencao] ASC) WITH (FILLFACTOR = 90)
);

