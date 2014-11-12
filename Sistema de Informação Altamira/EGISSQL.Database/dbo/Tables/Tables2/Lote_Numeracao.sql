CREATE TABLE [dbo].[Lote_Numeracao] (
    [cd_lote_numeracao]  INT          NOT NULL,
    [cd_numero_lote]     INT          NOT NULL,
    [nm_ref_numero_lote] VARCHAR (15) NULL,
    [qt_passo_lote]      FLOAT (53)   NULL,
    [ic_ano_lote]        CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [ic_estado_lote]     CHAR (1)     NULL,
    CONSTRAINT [PK_Lote_Numeracao] PRIMARY KEY CLUSTERED ([cd_lote_numeracao] ASC) WITH (FILLFACTOR = 90)
);

