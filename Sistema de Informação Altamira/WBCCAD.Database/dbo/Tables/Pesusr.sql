CREATE TABLE [dbo].[Pesusr] (
    [pesusr_codigo]          INT          NULL,
    [pesusr_senha]           NVARCHAR (8) NOT NULL,
    [pesusr_assinatura]      NVARCHAR (8) NULL,
    [pesusr_trocar_senha]    BIT          NOT NULL,
    [pesusr_proxima_troca]   DATETIME     NULL,
    [pesusr_bloquear_acesso] BIT          NOT NULL,
    [pesusr_validade]        DATETIME     NULL,
    [pesusr_desabilitado]    BIT          NOT NULL
);

