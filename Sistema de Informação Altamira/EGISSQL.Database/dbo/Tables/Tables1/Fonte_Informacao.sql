CREATE TABLE [dbo].[Fonte_Informacao] (
    [cd_fonte_informacao]         INT          NOT NULL,
    [nm_fonte_informacao]         VARCHAR (30) NOT NULL,
    [sg_fonte_informacao]         CHAR (10)    NOT NULL,
    [cd_usuario]                  INT          NOT NULL,
    [dt_usuario]                  DATETIME     NOT NULL,
    [ic_analise_fonte_informacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Fonte_Informacao] PRIMARY KEY CLUSTERED ([cd_fonte_informacao] ASC) WITH (FILLFACTOR = 90)
);

