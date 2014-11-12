CREATE TABLE [dbo].[mez_tipo_viga] (
    [nome]           NVARCHAR (255) NULL,
    [comprimento]    INT            NULL,
    [largura]        INT            NULL,
    [altura]         INT            NULL,
    [qtde_max]       INT            NULL,
    [qtde_min]       INT            NULL,
    [tipo]           NVARCHAR (255) NULL,
    [estilo]         NVARCHAR (255) NULL,
    [gp_acab]        NVARCHAR (255) NULL,
    [especial]       BIT            NOT NULL,
    [sigla_ref_viga] NVARCHAR (50)  NULL,
    [desenho]        NVARCHAR (50)  NULL,
    [wx]             FLOAT (53)     NULL,
    [ix]             FLOAT (53)     NULL
);

