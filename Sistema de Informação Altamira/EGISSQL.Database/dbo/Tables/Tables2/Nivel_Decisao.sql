CREATE TABLE [dbo].[Nivel_Decisao] (
    [cd_nivel_decisao]     INT          NOT NULL,
    [nm_nivel_decisao]     VARCHAR (40) NULL,
    [sg_nivel_decisao]     CHAR (10)    NULL,
    [ic_pad_nivel_decisao] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Nivel_Decisao] PRIMARY KEY CLUSTERED ([cd_nivel_decisao] ASC) WITH (FILLFACTOR = 90)
);

