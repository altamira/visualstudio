CREATE TABLE [dbo].[Desvio_Implantacao] (
    [cd_desvio_implantacao]      INT        NOT NULL,
    [dt_desvio_implantacao]      DATETIME   NOT NULL,
    [cd_cliente_sistema]         INT        NULL,
    [cd_consultor]               INT        NULL,
    [cd_motivo_desvio]           INT        NULL,
    [ds_desvio_implantacao]      TEXT       NULL,
    [qt_hora_desvio_implantacao] FLOAT (53) NULL,
    [cd_modulo]                  INT        NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    CONSTRAINT [PK_Desvio_Implantacao] PRIMARY KEY CLUSTERED ([cd_desvio_implantacao] ASC) WITH (FILLFACTOR = 90)
);

