CREATE TABLE [dbo].[Contribuicao_Adicional] (
    [cd_contribuicao_adicional] INT          NOT NULL,
    [nm_contribuicao_adicional] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Contribuicao_Adicional] PRIMARY KEY CLUSTERED ([cd_contribuicao_adicional] ASC) WITH (FILLFACTOR = 90)
);

