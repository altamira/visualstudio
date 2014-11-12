CREATE TABLE [dbo].[Cliente_Tipo_Pessoa] (
    [cd_tipo_pessoa] INT          NOT NULL,
    [nm_tipo_pessoa] VARCHAR (30) NOT NULL,
    [sg_tipo_pessoa] CHAR (10)    NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [dt_usuario]     DATETIME     NOT NULL,
    CONSTRAINT [PK_Cliente_Tipo_Pessoa] PRIMARY KEY CLUSTERED ([cd_tipo_pessoa] ASC) WITH (FILLFACTOR = 90)
);

