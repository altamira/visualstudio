CREATE TABLE [dbo].[Evento_Tributacao] (
    [cd_evento_tributacao]     INT          NOT NULL,
    [nm_evento_tributacao]     VARCHAR (30) NULL,
    [sg_evento_tributacao]     CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_ord_evento_tributacao] INT          NULL,
    CONSTRAINT [PK_Evento_Tributacao] PRIMARY KEY CLUSTERED ([cd_evento_tributacao] ASC) WITH (FILLFACTOR = 90)
);

