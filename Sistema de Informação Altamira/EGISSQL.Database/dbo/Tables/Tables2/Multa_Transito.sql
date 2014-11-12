CREATE TABLE [dbo].[Multa_Transito] (
    [cd_multa_transito]        INT          NOT NULL,
    [nm_multa_transito]        VARCHAR (60) NULL,
    [ds_multa_transito]        TEXT         NULL,
    [cd_artigo_multa_transito] CHAR (10)    NULL,
    [vl_multa_transito]        FLOAT (53)   NULL,
    [qt_ponto_multa_transito]  INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_enquadramento_multa]   VARCHAR (15) NULL,
    [ic_gravidade_multa]       CHAR (1)     NULL,
    CONSTRAINT [PK_Multa_Transito] PRIMARY KEY CLUSTERED ([cd_multa_transito] ASC) WITH (FILLFACTOR = 90)
);

