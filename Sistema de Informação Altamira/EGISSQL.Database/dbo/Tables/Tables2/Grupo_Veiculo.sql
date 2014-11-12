CREATE TABLE [dbo].[Grupo_Veiculo] (
    [cd_grupo_veiculo] INT          NOT NULL,
    [nm_grupo_veiculo] VARCHAR (40) NULL,
    [sg_grupo_veiculo] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Veiculo] PRIMARY KEY CLUSTERED ([cd_grupo_veiculo] ASC) WITH (FILLFACTOR = 90)
);

