CREATE TABLE [dbo].[Feriado] (
    [cd_feriado]        INT          NOT NULL,
    [nm_feriado]        VARCHAR (40) NOT NULL,
    [nm_fantasia]       CHAR (10)    NOT NULL,
    [sg_feriado]        CHAR (10)    NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    [ic_padrao_feriado] CHAR (1)     NULL,
    [dt_padrao_feriado] VARCHAR (5)  NULL,
    CONSTRAINT [PK_Feriado] PRIMARY KEY CLUSTERED ([cd_feriado] ASC) WITH (FILLFACTOR = 90)
);

