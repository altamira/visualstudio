CREATE TABLE [dbo].[CO_PlanoDeCorte] (
    [CodBobina]       CHAR (14)     NOT NULL,
    [PlanoDeCorte]    CHAR (10)     NOT NULL,
    [DataPlano]       SMALLDATETIME NOT NULL,
    [PrevisaoEntrega] SMALLDATETIME NOT NULL,
    [Tonelada]        FLOAT (53)    NOT NULL,
    [Largura]         FLOAT (53)    NOT NULL,
    [Rolo]            INT           NOT NULL,
    [Lock]            BINARY (8)    NULL
);

