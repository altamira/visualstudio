CREATE TABLE [dbo].[Tipo_Banimento] (
    [cd_tipo_banimento] INT          NOT NULL,
    [nm_tipo_banimento] VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Banimento] PRIMARY KEY CLUSTERED ([cd_tipo_banimento] ASC)
);

