CREATE TABLE [dbo].[Tipo_Logradouro] (
    [cd_tipo_logradouro] INT          NOT NULL,
    [nm_logradouro]      VARCHAR (30) NULL,
    [sg_logradouro]      CHAR (5)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Logradouro] PRIMARY KEY CLUSTERED ([cd_tipo_logradouro] ASC) WITH (FILLFACTOR = 90)
);

