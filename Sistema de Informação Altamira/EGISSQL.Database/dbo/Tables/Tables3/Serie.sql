CREATE TABLE [dbo].[Serie] (
    [cd_serie]      INT          NOT NULL,
    [nm_serie]      VARCHAR (40) NOT NULL,
    [sg_serie]      CHAR (15)    NOT NULL,
    [cd_tipo_serie] INT          NOT NULL,
    [cd_tipo_lucro] INT          NOT NULL,
    [cd_usuario]    INT          NOT NULL,
    [dt_usuario]    DATETIME     NOT NULL,
    CONSTRAINT [PK_Serie] PRIMARY KEY CLUSTERED ([cd_serie] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Serie_Tipo_Lucro] FOREIGN KEY ([cd_tipo_lucro]) REFERENCES [dbo].[Tipo_Lucro] ([cd_tipo_lucro])
);

