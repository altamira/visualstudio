CREATE TABLE [dbo].[Numero_Ossario] (
    [cd_numero_ossario] INT       NOT NULL,
    [cd_cemiterio]      INT       NULL,
    [cd_bloco_ossario]  INT       NULL,
    [sg_numero_ossario] CHAR (10) NULL,
    [cd_usuario]        INT       NULL,
    [dt_usuario]        DATETIME  NULL,
    CONSTRAINT [PK_Numero_Ossario] PRIMARY KEY CLUSTERED ([cd_numero_ossario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Numero_Ossario_Bloco_Ossario] FOREIGN KEY ([cd_bloco_ossario]) REFERENCES [dbo].[Bloco_Ossario] ([cd_bloco_ossario])
);

