CREATE TABLE [dbo].[Cliente_Concorrente] (
    [cd_cliente]                INT          NOT NULL,
    [cd_concorrente]            INT          NOT NULL,
    [qt_visita_concorrente]     INT          NULL,
    [ic_vendedor_concorrente]   CHAR (1)     NULL,
    [nm_vendedor_concorrente]   VARCHAR (40) NULL,
    [ds_observacao_concorrente] TEXT         NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL
);

