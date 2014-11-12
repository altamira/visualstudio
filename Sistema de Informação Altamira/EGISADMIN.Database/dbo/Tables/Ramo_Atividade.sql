CREATE TABLE [dbo].[Ramo_Atividade] (
    [cd_ramo_atividade] INT          NOT NULL,
    [nm_ramo_atividade] VARCHAR (20) NOT NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Ramo_Atividade] PRIMARY KEY CLUSTERED ([cd_ramo_atividade] ASC) WITH (FILLFACTOR = 90)
);

