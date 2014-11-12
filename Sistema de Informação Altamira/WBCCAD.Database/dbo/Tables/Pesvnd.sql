CREATE TABLE [dbo].[Pesvnd] (
    [pesvnd_codigo]           INT            NOT NULL,
    [pesvnd_comis_flag]       BIT            CONSTRAINT [DF_Pesvnd_pesvnd_comis_flag] DEFAULT ((0)) NOT NULL,
    [pesvnd_comis_tipo]       NVARCHAR (20)  NULL,
    [pesvnd_comis_percentual] FLOAT (53)     NULL,
    [pesvnd_tipo]             NVARCHAR (20)  NULL,
    [pesvnd_desabilitado]     BIT            CONSTRAINT [DF_Pesvnd_pesvnd_desabilitado] DEFAULT ((0)) NOT NULL,
    [PESVND_CARGO]            NVARCHAR (50)  NULL,
    [PESVND_IMAGEM]           NVARCHAR (MAX) NULL,
    [idPesvnd]                INT            IDENTITY (1, 1) NOT NULL
);

