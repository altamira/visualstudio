CREATE TABLE [dbo].[gond_lista] (
    [lista]                             NVARCHAR (50) NULL,
    [ESCONDER]                          BIT           NULL,
    [esconder_perfil]                   BIT           NULL,
    [travar_representante]              BIT           NULL,
    [tipo_cad]                          NVARCHAR (10) NULL,
    [sufixo]                            NVARCHAR (2)  NULL,
    [pedir_dados_armazenagem]           BIT           NULL,
    [base_padrao]                       NVARCHAR (50) NULL,
    [Utilizar_somente_para_este_perfil] NVARCHAR (50) NULL,
    [Utilizar_travessas]                BIT           NULL,
    [idGondLista]                       INT           IDENTITY (1, 1) NOT NULL
);

