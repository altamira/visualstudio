CREATE TABLE [dbo].[CIAP_Demonstrativo] (
    [cd_ciap]         INT        NOT NULL,
    [cd_parcela]      INT        NOT NULL,
    [qt_mes]          INT        NULL,
    [qt_ano]          INT        NULL,
    [qt_fator]        FLOAT (53) NULL,
    [vl_icms]         FLOAT (53) NULL,
    [cd_usuario]      INT        NULL,
    [dt_usuario]      DATETIME   NULL,
    [dt_parcela_ciap] DATETIME   NULL,
    CONSTRAINT [PK_CIAP_Demonstrativo] PRIMARY KEY CLUSTERED ([cd_ciap] ASC, [cd_parcela] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CIAP_Demonstrativo_Ciap] FOREIGN KEY ([cd_ciap]) REFERENCES [dbo].[Ciap] ([cd_ciap])
);

