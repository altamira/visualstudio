CREATE TABLE [dbo].[Pesquisa] (
    [cd_pesquisa]          INT          NOT NULL,
    [nm_pesquisa]          VARCHAR (40) NOT NULL,
    [sg_pesquisa]          CHAR (10)    NOT NULL,
    [ds_pesquisa]          TEXT         NOT NULL,
    [dt_base_pesquisa]     DATETIME     NOT NULL,
    [dt_ultima_pesquisa]   DATETIME     NOT NULL,
    [qt_cliente_pesquisa]  FLOAT (53)   NOT NULL,
    [qt_resposta_pesquisa] FLOAT (53)   NOT NULL,
    [cd_tipo_pesquisa]     INT          NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NULL
);

