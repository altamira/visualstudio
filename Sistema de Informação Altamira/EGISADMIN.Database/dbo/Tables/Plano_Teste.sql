CREATE TABLE [dbo].[Plano_Teste] (
    [cd_plano_teste] INT          NOT NULL,
    [nm_plano_teste] VARCHAR (50) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Plano_Teste] PRIMARY KEY CLUSTERED ([cd_plano_teste] ASC) WITH (FILLFACTOR = 90)
);

