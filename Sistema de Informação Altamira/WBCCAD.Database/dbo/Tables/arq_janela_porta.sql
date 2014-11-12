CREATE TABLE [dbo].[arq_janela_porta] (
    [descricao]          NVARCHAR (50)  NULL,
    [desenho]            NVARCHAR (100) NULL,
    [medida_comprimento] INT            NULL,
    [tipo]               NVARCHAR (50)  NULL,
    [espelhar_1]         BIT            NOT NULL,
    [medida_altura]      INT            NULL,
    [espelhar_2]         BIT            NOT NULL,
    [Altura_peitoril]    FLOAT (53)     NULL
);

