CREATE TABLE [dbo].[Tipo_Cotacao] (
    [cd_tipo_cotacao]        INT          NOT NULL,
    [nm_tipo_cotacao]        VARCHAR (30) NOT NULL,
    [sg_tipo_cotacao]        CHAR (10)    NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [ic_padrao_tipo_cotacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Cotacao] PRIMARY KEY CLUSTERED ([cd_tipo_cotacao] ASC) WITH (FILLFACTOR = 90)
);

