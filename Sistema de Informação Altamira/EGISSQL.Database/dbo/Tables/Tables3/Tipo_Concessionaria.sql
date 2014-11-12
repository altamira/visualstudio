CREATE TABLE [dbo].[Tipo_Concessionaria] (
    [cd_tipo_concessionaria] INT          NOT NULL,
    [nm_tipo_concessionaria] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Concessionaria] PRIMARY KEY CLUSTERED ([cd_tipo_concessionaria] ASC)
);

