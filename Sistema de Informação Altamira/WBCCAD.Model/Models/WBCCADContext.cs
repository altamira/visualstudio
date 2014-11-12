using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using WBCCAD.Model.Models.Mapping;

namespace WBCCAD.Model.Models
{
    public partial class WBCCADContext : DbContext
    {
        static WBCCADContext()
        {
            Database.SetInitializer<WBCCADContext>(null);
        }

        public WBCCADContext()
            : base("Name=WBCCADContext")
        {
        }

        public DbSet<Aco> Acoes { get; set; }
        public DbSet<AcoesGrupos> AcoesGrupos { get; set; }
        public DbSet<AcoesUsuario> AcoesUsuarios { get; set; }
        public DbSet<Aplicaco> Aplicacoes { get; set; }
        public DbSet<arm_escada_acessorios> arm_escada_acessorios { get; set; }
        public DbSet<arm_escada_parametros> arm_escada_parametros { get; set; }
        public DbSet<arm_escada_tipo_piso> arm_escada_tipo_piso { get; set; }
        public DbSet<arm_piso_acessorios> arm_piso_acessorios { get; set; }
        public DbSet<arm_piso_acessorios_GEN> arm_piso_acessorios_GEN { get; set; }
        public DbSet<arm_piso_acessorios_GEN_> arm_piso_acessorios_GEN_ { get; set; }
        public DbSet<arm_piso_acessorios_GEN_bk> arm_piso_acessorios_GEN_bk { get; set; }
        public DbSet<arm_piso_tipo_cantoneira> arm_piso_tipo_cantoneira { get; set; }
        public DbSet<arq_janela_porta> arq_janela_porta { get; set; }
        public DbSet<cabos_eletro_acessorios> cabos_eletro_acessorios { get; set; }
        public DbSet<cabos_eletro_area> cabos_eletro_area { get; set; }
        public DbSet<cam_aces_mod> cam_aces_mod { get; set; }
        public DbSet<cam_definir> cam_definir { get; set; }
        public DbSet<cam_detalhes_kit> cam_detalhes_kit { get; set; }
        public DbSet<cam_frc> cam_frc { get; set; }
        public DbSet<cam_prt> cam_prt { get; set; }
        public DbSet<CartasRTF> CartasRTFs { get; set; }
        public DbSet<cfosecao> cfosecaos { get; set; }
        public DbSet<check_list> check_list { get; set; }
        public DbSet<conf_empresa> conf_empresa { get; set; }
        public DbSet<Config_Geral> Config_Geral { get; set; }
        public DbSet<ConfiguracoesTabela> ConfiguracoesTabelas { get; set; }
        public DbSet<dados_projeto> dados_projeto { get; set; }
        public DbSet<DadosImpressaoOrcamento> DadosImpressaoOrcamentoes { get; set; }
        public DbSet<fabricante> fabricantes { get; set; }
        public DbSet<FatoresCalculo> FatoresCalculoes { get; set; }
        public DbSet<FormulaCalculo> FormulaCalculoes { get; set; }
        public DbSet<gab_acsg> gab_acsg { get; set; }
        public DbSet<gab_cab> gab_cab { get; set; }
        public DbSet<gab_cabdet> gab_cabdet { get; set; }
        public DbSet<gab_crtgab> gab_crtgab { get; set; }
        public DbSet<gab_gabacsg> gab_gabacsg { get; set; }
        public DbSet<gab_gabgab> gab_gabgab { get; set; }
        public DbSet<gab_gabutl> gab_gabutl { get; set; }
        public DbSet<gab_medgab> gab_medgab { get; set; }
        public DbSet<gab_param_med_aces> gab_param_med_aces { get; set; }
        public DbSet<gab_param_med_crt> gab_param_med_crt { get; set; }
        public DbSet<gab_tipo> gab_tipo { get; set; }
        public DbSet<gab_util> gab_util { get; set; }
        public DbSet<gen_acab> gen_acab { get; set; }
        public DbSet<gen_chave_busca> gen_chave_busca { get; set; }
        public DbSet<gen_conden> gen_conden { get; set; }
        public DbSet<gen_dados_WBCCAD> gen_dados_WBCCAD { get; set; }
        public DbSet<gen_dtc> gen_dtc { get; set; }
        public DbSet<gen_frequencia> gen_frequencia { get; set; }
        public DbSet<gen_grp_acab> gen_grp_acab { get; set; }
        public DbSet<gen_param4> gen_param4 { get; set; }
        public DbSet<gen_param5> gen_param5 { get; set; }
        public DbSet<gen_rel_eqpto_grp_acab> gen_rel_eqpto_grp_acab { get; set; }
        public DbSet<gen_rel_grp_acab_cor> gen_rel_grp_acab_cor { get; set; }
        public DbSet<gen_set_util> gen_set_util { get; set; }
        public DbSet<gen_setores> gen_setores { get; set; }
        public DbSet<gen_temp_condensacao> gen_temp_condensacao { get; set; }
        public DbSet<gen_temp_condensacao_uc> gen_temp_condensacao_uc { get; set; }
        public DbSet<gen_temp_evaporacao> gen_temp_evaporacao { get; set; }
        public DbSet<gen_tensao> gen_tensao { get; set; }
        public DbSet<gen_utilizacoes> gen_utilizacoes { get; set; }
        public DbSet<GenGrpPreco> GenGrpPrecoes { get; set; }
        public DbSet<gond_aces_alt_eqv> gond_aces_alt_eqv { get; set; }
        public DbSet<gond_aces_pniv_med> gond_aces_pniv_med { get; set; }
        public DbSet<gond_acess> gond_acess { get; set; }
        public DbSet<gond_acess_comp_eqv> gond_acess_comp_eqv { get; set; }
        public DbSet<gond_acess_prof_eqv> gond_acess_prof_eqv { get; set; }
        public DbSet<gond_acess_rel_prof> gond_acess_rel_prof { get; set; }
        public DbSet<gond_alt> gond_alt { get; set; }
        public DbSet<gond_alt_crt> gond_alt_crt { get; set; }
        public DbSet<gond_ang> gond_ang { get; set; }
        public DbSet<gond_cjtos> gond_cjtos { get; set; }
        public DbSet<gond_cjtos_aces> gond_cjtos_aces { get; set; }
        public DbSet<gond_cjtos_alt> gond_cjtos_alt { get; set; }
        public DbSet<gond_cjtos_compr> gond_cjtos_compr { get; set; }
        public DbSet<gond_cjtos_cons_elet_med> gond_cjtos_cons_elet_med { get; set; }
        public DbSet<gond_cjtos_listas> gond_cjtos_listas { get; set; }
        public DbSet<gond_cjtos_prof> gond_cjtos_prof { get; set; }
        public DbSet<gond_compr> gond_compr { get; set; }
        public DbSet<gond_compr_crt> gond_compr_crt { get; set; }
        public DbSet<gond_corte_ang> gond_corte_ang { get; set; }
        public DbSet<gond_corte_bases> gond_corte_bases { get; set; }
        public DbSet<gond_corte_cjtos> gond_corte_cjtos { get; set; }
        public DbSet<gond_corte_est_frt> gond_corte_est_frt { get; set; }
        public DbSet<gond_corte_est_sup> gond_corte_est_sup { get; set; }
        public DbSet<gond_corte_frentes> gond_corte_frentes { get; set; }
        public DbSet<gond_corte_fundos> gond_corte_fundos { get; set; }
        public DbSet<gond_corte_setores> gond_corte_setores { get; set; }
        public DbSet<gond_corte_util> gond_corte_util { get; set; }
        public DbSet<gond_dados_corte> gond_dados_corte { get; set; }
        public DbSet<gond_grafia_diversos> gond_grafia_diversos { get; set; }
        public DbSet<gond_lista> gond_lista { get; set; }
        public DbSet<gond_prof> gond_prof { get; set; }
        public DbSet<gond_prof_crt> gond_prof_crt { get; set; }
        public DbSet<gond_prof_rel_prof_sup> gond_prof_rel_prof_sup { get; set; }
        public DbSet<gond_regra_cjto_base> gond_regra_cjto_base { get; set; }
        public DbSet<gond_rel_compr_pta> gond_rel_compr_pta { get; set; }
        public DbSet<gond_rel_compr_pta_prof_pta> gond_rel_compr_pta_prof_pta { get; set; }
        public DbSet<gond_rel_prof_base> gond_rel_prof_base { get; set; }
        public DbSet<gond_rel_prof_prof_ponta> gond_rel_prof_prof_ponta { get; set; }
        public DbSet<gond_rest> gond_rest { get; set; }
        public DbSet<gond_rest_acess> gond_rest_acess { get; set; }
        public DbSet<gond_rest_alt> gond_rest_alt { get; set; }
        public DbSet<gond_rest_ang> gond_rest_ang { get; set; }
        public DbSet<gond_rest_cjto> gond_rest_cjto { get; set; }
        public DbSet<gond_rest_compr> gond_rest_compr { get; set; }
        public DbSet<gond_rest_corte> gond_rest_corte { get; set; }
        public DbSet<gond_rest_frente> gond_rest_frente { get; set; }
        public DbSet<gond_rest_prof> gond_rest_prof { get; set; }
        public DbSet<gond_tipo> gond_tipo { get; set; }
        public DbSet<gond_tp_frt> gond_tp_frt { get; set; }
        public DbSet<GrpPreco> GrpPrecoes { get; set; }
        public DbSet<Grupos> Grupos { get; set; }
        public DbSet<GruposUsuario> GruposUsuarios { get; set; }
        public DbSet<idmdtc> idmdtcs { get; set; }
        public DbSet<idmorc> idmorcs { get; set; }
        public DbSet<idmprd> idmprds { get; set; }
        public DbSet<INTEGRACAO_ORCCAB> INTEGRACAO_ORCCAB { get; set; }
        public DbSet<INTEGRACAO_ORCINC> INTEGRACAO_ORCINC { get; set; }
        public DbSet<INTEGRACAO_ORCIND> INTEGRACAO_ORCIND { get; set; }
        public DbSet<INTEGRACAO_ORCITM> INTEGRACAO_ORCITM { get; set; }
        public DbSet<INTEGRACAO_ORCPRD> INTEGRACAO_ORCPRD { get; set; }
        public DbSet<INTEGRACAO_ORCPRDARV> INTEGRACAO_ORCPRDARV { get; set; }
        public DbSet<INTEGRACAO_ORCSIT> INTEGRACAO_ORCSIT { get; set; }
        public DbSet<Item> Items { get; set; }
        public DbSet<ItemRel> ItemRels { get; set; }
        public DbSet<ListaFatoresCalculo> ListaFatoresCalculoes { get; set; }
        public DbSet<Log_sys> Log_sys { get; set; }
        public DbSet<mez_acessorios> mez_acessorios { get; set; }
        public DbSet<mez_acessorios_bk> mez_acessorios_bk { get; set; }
        public DbSet<mez_escoamentos> mez_escoamentos { get; set; }
        public DbSet<mez_inercias> mez_inercias { get; set; }
        public DbSet<mez_tipo_cargas> mez_tipo_cargas { get; set; }
        public DbSet<mez_tipo_piso> mez_tipo_piso { get; set; }
        public DbSet<mez_tipo_projeto> mez_tipo_projeto { get; set; }
        public DbSet<mez_tipo_viga> mez_tipo_viga { get; set; }
        public DbSet<mob_aces> mob_aces { get; set; }
        public DbSet<mob_aces_dependente> mob_aces_dependente { get; set; }
        public DbSet<mob_aces_rest> mob_aces_rest { get; set; }
        public DbSet<mob_cadastro> mob_cadastro { get; set; }
        public DbSet<mob_cadastro_caracteristicas> mob_cadastro_caracteristicas { get; set; }
        public DbSet<mob_cadastro_caracteristicas_sigla> mob_cadastro_caracteristicas_sigla { get; set; }
        public DbSet<mob_cadastro_descricoes_sigla> mob_cadastro_descricoes_sigla { get; set; }
        public DbSet<mob_grupo> mob_grupo { get; set; }
        public DbSet<mob_grupos_restricoes> mob_grupos_restricoes { get; set; }
        public DbSet<Mob_SubGrp> Mob_SubGrp { get; set; }
        public DbSet<mob_textos> mob_textos { get; set; }
        public DbSet<Nivei> Niveis { get; set; }
        public DbSet<OrcAco> OrcAcoes { get; set; }
        public DbSet<ORCCAB> ORCCABs { get; set; }
        public DbSet<orccab1> orccab1 { get; set; }
        public DbSet<OrcCal> OrcCals { get; set; }
        public DbSet<OrcCalDet> OrcCalDets { get; set; }
        public DbSet<OrcCrt> OrcCrts { get; set; }
        public DbSet<OrcDet> OrcDets { get; set; }
        public DbSet<ORCDETAUX> ORCDETAUXes { get; set; }
        public DbSet<OrcDetPad> OrcDetPads { get; set; }
        public DbSet<OrcDtc> OrcDtcs { get; set; }
        public DbSet<OrcGrid> OrcGrids { get; set; }
        public DbSet<OrcHist> OrcHists { get; set; }
        public DbSet<OrcItm> OrcItms { get; set; }
        public DbSet<OrcLog> OrcLogs { get; set; }
        public DbSet<Orclst> Orclsts { get; set; }
        public DbSet<OrcMat> OrcMats { get; set; }
        public DbSet<OrcMat_Grp> OrcMat_Grp { get; set; }
        public DbSet<OrcMatDet> OrcMatDets { get; set; }
        public DbSet<OrcMatDetAdicional> OrcMatDetAdicionals { get; set; }
        public DbSet<OrcMatExtra> OrcMatExtras { get; set; }
        public DbSet<Orcmot> Orcmots { get; set; }
        public DbSet<OrcPrc> OrcPrcs { get; set; }
        public DbSet<ORCPRCVAR> ORCPRCVARs { get; set; }
        public DbSet<Orcst> Orcsts { get; set; }
        public DbSet<OrcTipVen> OrcTipVens { get; set; }
        public DbSet<OrcVar> OrcVars { get; set; }
        public DbSet<OrcVarCalculo> OrcVarCalculoes { get; set; }
        public DbSet<ORCVARPRJ> ORCVARPRJs { get; set; }
        public DbSet<OrcVarUsr> OrcVarUsrs { get; set; }
        public DbSet<PADVARPRJ> PADVARPRJs { get; set; }
        public DbSet<PesAgt> PesAgts { get; set; }
        public DbSet<Pescab> Pescabs { get; set; }
        public DbSet<Pescli> Pesclis { get; set; }
        public DbSet<Peslog> Peslogs { get; set; }
        public DbSet<pesorc> pesorcs { get; set; }
        public DbSet<pesprj> pesprjs { get; set; }
        public DbSet<Pessup> Pessups { get; set; }
        public DbSet<Pesusr> Pesusrs { get; set; }
        public DbSet<Pesvnd> Pesvnds { get; set; }
        public DbSet<prccab> prccabs { get; set; }
        public DbSet<prcprd> prcprds { get; set; }
        public DbSet<prcprdbk> prcprdbks { get; set; }
        public DbSet<prcprdfat> prcprdfats { get; set; }
        public DbSet<prcprdfatbk> prcprdfatbks { get; set; }
        public DbSet<prdchb> prdchbs { get; set; }
        public DbSet<prdfam> prdfams { get; set; }
        public DbSet<PRDFAM_GENGRPPRC> PRDFAM_GENGRPPRC { get; set; }
        public DbSet<prdgrp> prdgrps { get; set; }
        public DbSet<prdgrpAuxiliar> prdgrpAuxiliars { get; set; }
        public DbSet<prdorc> prdorcs { get; set; }
        public DbSet<RegrasCalculo> RegrasCalculoes { get; set; }
        public DbSet<Relatorio> Relatorios { get; set; }
        public DbSet<Secao> Secaos { get; set; }
        public DbSet<sysdiagram> sysdiagrams { get; set; }
        public DbSet<tab_cadastros> tab_cadastros { get; set; }
        public DbSet<TABGRPIMP> TABGRPIMPs { get; set; }
        public DbSet<TABREGRA> TABREGRAs { get; set; }
        public DbSet<TABREGRA_backup> TABREGRA_backups { get; set; }
        public DbSet<TABTIPVEN> TABTIPVENs { get; set; }
        public DbSet<tabuf> tabufs { get; set; }
        public DbSet<tbl_consumo_tipo> tbl_consumo_tipo { get; set; }
        public DbSet<tbl_tipo_cobrar> tbl_tipo_cobrar { get; set; }
        public DbSet<tblDados_projeto> tblDados_projeto { get; set; }
        public DbSet<tblDesconto> tblDescontoes { get; set; }
        public DbSet<tblGrupoBusca> tblGrupoBuscas { get; set; }
        public DbSet<tblOpcao> tblOpcaos { get; set; }
        public DbSet<TBLPAI> TBLPAIS { get; set; }
        public DbSet<tblPgtCab> tblPgtCabs { get; set; }
        public DbSet<tblPgtCabModalidade> tblPgtCabModalidades { get; set; }
        public DbSet<tblPrzMed> tblPrzMeds { get; set; }
        public DbSet<tipo_Alt_conceito> tipo_Alt_conceito { get; set; }
        public DbSet<tipo_Compr_conceito> tipo_Compr_conceito { get; set; }
        public DbSet<tipo_desenhar> tipo_desenhar { get; set; }
        public DbSet<Tipo_Inc_no_mod> Tipo_Inc_no_mod { get; set; }
        public DbSet<tipo_insercao> tipo_insercao { get; set; }
        public DbSet<tipo_prof_conceito> tipo_prof_conceito { get; set; }
        public DbSet<tipo_qtde_p_nivel_formula> tipo_qtde_p_nivel_formula { get; set; }
        public DbSet<tipo_resfriamento> tipo_resfriamento { get; set; }
        public DbSet<tipo_tipo> tipo_tipo { get; set; }
        public DbSet<tipo_variacao> tipo_variacao { get; set; }
        public DbSet<TipoItem> TipoItems { get; set; }
        public DbSet<TiposAco> TiposAcoes { get; set; }
        public DbSet<Traducao> Traducaos { get; set; }
        public DbSet<TstCab> TstCabs { get; set; }
        public DbSet<tubula_gas_refrigerante> tubula_gas_refrigerante { get; set; }
        public DbSet<Usuario> Usuarios { get; set; }
        public DbSet<varusr> varusrs { get; set; }
        public DbSet<varusr_rel_tipo> varusr_rel_tipo { get; set; }
        public DbSet<varusrorc> varusrorcs { get; set; }
        public DbSet<TABLES_AND_COLUMNS_VIEW> TABLES_AND_COLUMNS_VIEWs { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Configurations.Add(new AcoMap());
            modelBuilder.Configurations.Add(new AcoesGruposMap());
            modelBuilder.Configurations.Add(new AcoesUsuarioMap());
            modelBuilder.Configurations.Add(new AplicacoMap());
            modelBuilder.Configurations.Add(new arm_escada_acessoriosMap());
            modelBuilder.Configurations.Add(new arm_escada_parametrosMap());
            modelBuilder.Configurations.Add(new arm_escada_tipo_pisoMap());
            modelBuilder.Configurations.Add(new arm_piso_acessoriosMap());
            modelBuilder.Configurations.Add(new arm_piso_acessorios_GENMap());
            modelBuilder.Configurations.Add(new arm_piso_acessorios_GEN_Map());
            modelBuilder.Configurations.Add(new arm_piso_acessorios_GEN_bkMap());
            modelBuilder.Configurations.Add(new arm_piso_tipo_cantoneiraMap());
            modelBuilder.Configurations.Add(new arq_janela_portaMap());
            modelBuilder.Configurations.Add(new cabos_eletro_acessoriosMap());
            modelBuilder.Configurations.Add(new cabos_eletro_areaMap());
            modelBuilder.Configurations.Add(new cam_aces_modMap());
            modelBuilder.Configurations.Add(new cam_definirMap());
            modelBuilder.Configurations.Add(new cam_detalhes_kitMap());
            modelBuilder.Configurations.Add(new cam_frcMap());
            modelBuilder.Configurations.Add(new cam_prtMap());
            modelBuilder.Configurations.Add(new CartasRTFMap());
            modelBuilder.Configurations.Add(new cfosecaoMap());
            modelBuilder.Configurations.Add(new check_listMap());
            modelBuilder.Configurations.Add(new conf_empresaMap());
            modelBuilder.Configurations.Add(new Config_GeralMap());
            modelBuilder.Configurations.Add(new ConfiguracoesTabelaMap());
            modelBuilder.Configurations.Add(new dados_projetoMap());
            modelBuilder.Configurations.Add(new DadosImpressaoOrcamentoMap());
            modelBuilder.Configurations.Add(new fabricanteMap());
            modelBuilder.Configurations.Add(new FatoresCalculoMap());
            modelBuilder.Configurations.Add(new FormulaCalculoMap());
            modelBuilder.Configurations.Add(new gab_acsgMap());
            modelBuilder.Configurations.Add(new gab_cabMap());
            modelBuilder.Configurations.Add(new gab_cabdetMap());
            modelBuilder.Configurations.Add(new gab_crtgabMap());
            modelBuilder.Configurations.Add(new gab_gabacsgMap());
            modelBuilder.Configurations.Add(new gab_gabgabMap());
            modelBuilder.Configurations.Add(new gab_gabutlMap());
            modelBuilder.Configurations.Add(new gab_medgabMap());
            modelBuilder.Configurations.Add(new gab_param_med_acesMap());
            modelBuilder.Configurations.Add(new gab_param_med_crtMap());
            modelBuilder.Configurations.Add(new gab_tipoMap());
            modelBuilder.Configurations.Add(new gab_utilMap());
            modelBuilder.Configurations.Add(new gen_acabMap());
            modelBuilder.Configurations.Add(new gen_chave_buscaMap());
            modelBuilder.Configurations.Add(new gen_condenMap());
            modelBuilder.Configurations.Add(new gen_dados_WBCCADMap());
            modelBuilder.Configurations.Add(new gen_dtcMap());
            modelBuilder.Configurations.Add(new gen_frequenciaMap());
            modelBuilder.Configurations.Add(new gen_grp_acabMap());
            modelBuilder.Configurations.Add(new gen_param4Map());
            modelBuilder.Configurations.Add(new gen_param5Map());
            modelBuilder.Configurations.Add(new gen_rel_eqpto_grp_acabMap());
            modelBuilder.Configurations.Add(new gen_rel_grp_acab_corMap());
            modelBuilder.Configurations.Add(new gen_set_utilMap());
            modelBuilder.Configurations.Add(new gen_setoresMap());
            modelBuilder.Configurations.Add(new gen_temp_condensacaoMap());
            modelBuilder.Configurations.Add(new gen_temp_condensacao_ucMap());
            modelBuilder.Configurations.Add(new gen_temp_evaporacaoMap());
            modelBuilder.Configurations.Add(new gen_tensaoMap());
            modelBuilder.Configurations.Add(new gen_utilizacoesMap());
            modelBuilder.Configurations.Add(new GenGrpPrecoMap());
            modelBuilder.Configurations.Add(new gond_aces_alt_eqvMap());
            modelBuilder.Configurations.Add(new gond_aces_pniv_medMap());
            modelBuilder.Configurations.Add(new gond_acessMap());
            modelBuilder.Configurations.Add(new gond_acess_comp_eqvMap());
            modelBuilder.Configurations.Add(new gond_acess_prof_eqvMap());
            modelBuilder.Configurations.Add(new gond_acess_rel_profMap());
            modelBuilder.Configurations.Add(new gond_altMap());
            modelBuilder.Configurations.Add(new gond_alt_crtMap());
            modelBuilder.Configurations.Add(new gond_angMap());
            modelBuilder.Configurations.Add(new gond_cjtosMap());
            modelBuilder.Configurations.Add(new gond_cjtos_acesMap());
            modelBuilder.Configurations.Add(new gond_cjtos_altMap());
            modelBuilder.Configurations.Add(new gond_cjtos_comprMap());
            modelBuilder.Configurations.Add(new gond_cjtos_cons_elet_medMap());
            modelBuilder.Configurations.Add(new gond_cjtos_listasMap());
            modelBuilder.Configurations.Add(new gond_cjtos_profMap());
            modelBuilder.Configurations.Add(new gond_comprMap());
            modelBuilder.Configurations.Add(new gond_compr_crtMap());
            modelBuilder.Configurations.Add(new gond_corte_angMap());
            modelBuilder.Configurations.Add(new gond_corte_basesMap());
            modelBuilder.Configurations.Add(new gond_corte_cjtosMap());
            modelBuilder.Configurations.Add(new gond_corte_est_frtMap());
            modelBuilder.Configurations.Add(new gond_corte_est_supMap());
            modelBuilder.Configurations.Add(new gond_corte_frentesMap());
            modelBuilder.Configurations.Add(new gond_corte_fundosMap());
            modelBuilder.Configurations.Add(new gond_corte_setoresMap());
            modelBuilder.Configurations.Add(new gond_corte_utilMap());
            modelBuilder.Configurations.Add(new gond_dados_corteMap());
            modelBuilder.Configurations.Add(new gond_grafia_diversosMap());
            modelBuilder.Configurations.Add(new gond_listaMap());
            modelBuilder.Configurations.Add(new gond_profMap());
            modelBuilder.Configurations.Add(new gond_prof_crtMap());
            modelBuilder.Configurations.Add(new gond_prof_rel_prof_supMap());
            modelBuilder.Configurations.Add(new gond_regra_cjto_baseMap());
            modelBuilder.Configurations.Add(new gond_rel_compr_ptaMap());
            modelBuilder.Configurations.Add(new gond_rel_compr_pta_prof_ptaMap());
            modelBuilder.Configurations.Add(new gond_rel_prof_baseMap());
            modelBuilder.Configurations.Add(new gond_rel_prof_prof_pontaMap());
            modelBuilder.Configurations.Add(new gond_restMap());
            modelBuilder.Configurations.Add(new gond_rest_acessMap());
            modelBuilder.Configurations.Add(new gond_rest_altMap());
            modelBuilder.Configurations.Add(new gond_rest_angMap());
            modelBuilder.Configurations.Add(new gond_rest_cjtoMap());
            modelBuilder.Configurations.Add(new gond_rest_comprMap());
            modelBuilder.Configurations.Add(new gond_rest_corteMap());
            modelBuilder.Configurations.Add(new gond_rest_frenteMap());
            modelBuilder.Configurations.Add(new gond_rest_profMap());
            modelBuilder.Configurations.Add(new gond_tipoMap());
            modelBuilder.Configurations.Add(new gond_tp_frtMap());
            modelBuilder.Configurations.Add(new GrpPrecoMap());
            modelBuilder.Configurations.Add(new GruposMap());
            modelBuilder.Configurations.Add(new GruposUsuarioMap());
            modelBuilder.Configurations.Add(new idmdtcMap());
            modelBuilder.Configurations.Add(new idmorcMap());
            modelBuilder.Configurations.Add(new idmprdMap());
            modelBuilder.Configurations.Add(new INTEGRACAO_ORCCABMap());
            modelBuilder.Configurations.Add(new INTEGRACAO_ORCINCMap());
            modelBuilder.Configurations.Add(new INTEGRACAO_ORCINDMap());
            modelBuilder.Configurations.Add(new INTEGRACAO_ORCITMMap());
            modelBuilder.Configurations.Add(new INTEGRACAO_ORCPRDMap());
            modelBuilder.Configurations.Add(new INTEGRACAO_ORCPRDARVMap());
            modelBuilder.Configurations.Add(new INTEGRACAO_ORCSITMap());
            modelBuilder.Configurations.Add(new ItemMap());
            modelBuilder.Configurations.Add(new ItemRelMap());
            modelBuilder.Configurations.Add(new ListaFatoresCalculoMap());
            modelBuilder.Configurations.Add(new Log_sysMap());
            modelBuilder.Configurations.Add(new mez_acessoriosMap());
            modelBuilder.Configurations.Add(new mez_acessorios_bkMap());
            modelBuilder.Configurations.Add(new mez_escoamentosMap());
            modelBuilder.Configurations.Add(new mez_inerciasMap());
            modelBuilder.Configurations.Add(new mez_tipo_cargasMap());
            modelBuilder.Configurations.Add(new mez_tipo_pisoMap());
            modelBuilder.Configurations.Add(new mez_tipo_projetoMap());
            modelBuilder.Configurations.Add(new mez_tipo_vigaMap());
            modelBuilder.Configurations.Add(new mob_acesMap());
            modelBuilder.Configurations.Add(new mob_aces_dependenteMap());
            modelBuilder.Configurations.Add(new mob_aces_restMap());
            modelBuilder.Configurations.Add(new mob_cadastroMap());
            modelBuilder.Configurations.Add(new mob_cadastro_caracteristicasMap());
            modelBuilder.Configurations.Add(new mob_cadastro_caracteristicas_siglaMap());
            modelBuilder.Configurations.Add(new mob_cadastro_descricoes_siglaMap());
            modelBuilder.Configurations.Add(new mob_grupoMap());
            modelBuilder.Configurations.Add(new mob_grupos_restricoesMap());
            modelBuilder.Configurations.Add(new Mob_SubGrpMap());
            modelBuilder.Configurations.Add(new mob_textosMap());
            modelBuilder.Configurations.Add(new NiveiMap());
            modelBuilder.Configurations.Add(new OrcAcoMap());
            modelBuilder.Configurations.Add(new ORCCABMap());
            modelBuilder.Configurations.Add(new orccab1Map());
            modelBuilder.Configurations.Add(new OrcCalMap());
            modelBuilder.Configurations.Add(new OrcCalDetMap());
            modelBuilder.Configurations.Add(new OrcCrtMap());
            modelBuilder.Configurations.Add(new OrcDetMap());
            modelBuilder.Configurations.Add(new ORCDETAUXMap());
            modelBuilder.Configurations.Add(new OrcDetPadMap());
            modelBuilder.Configurations.Add(new OrcDtcMap());
            modelBuilder.Configurations.Add(new OrcGridMap());
            modelBuilder.Configurations.Add(new OrcHistMap());
            modelBuilder.Configurations.Add(new OrcItmMap());
            modelBuilder.Configurations.Add(new OrcLogMap());
            modelBuilder.Configurations.Add(new OrclstMap());
            modelBuilder.Configurations.Add(new OrcMatMap());
            modelBuilder.Configurations.Add(new OrcMat_GrpMap());
            modelBuilder.Configurations.Add(new OrcMatDetMap());
            modelBuilder.Configurations.Add(new OrcMatDetAdicionalMap());
            modelBuilder.Configurations.Add(new OrcMatExtraMap());
            modelBuilder.Configurations.Add(new OrcmotMap());
            modelBuilder.Configurations.Add(new OrcPrcMap());
            modelBuilder.Configurations.Add(new ORCPRCVARMap());
            modelBuilder.Configurations.Add(new OrcstMap());
            modelBuilder.Configurations.Add(new OrcTipVenMap());
            modelBuilder.Configurations.Add(new OrcVarMap());
            modelBuilder.Configurations.Add(new OrcVarCalculoMap());
            modelBuilder.Configurations.Add(new ORCVARPRJMap());
            modelBuilder.Configurations.Add(new OrcVarUsrMap());
            modelBuilder.Configurations.Add(new PADVARPRJMap());
            modelBuilder.Configurations.Add(new PesAgtMap());
            modelBuilder.Configurations.Add(new PescabMap());
            modelBuilder.Configurations.Add(new PescliMap());
            modelBuilder.Configurations.Add(new PeslogMap());
            modelBuilder.Configurations.Add(new pesorcMap());
            modelBuilder.Configurations.Add(new pesprjMap());
            modelBuilder.Configurations.Add(new PessupMap());
            modelBuilder.Configurations.Add(new PesusrMap());
            modelBuilder.Configurations.Add(new PesvndMap());
            modelBuilder.Configurations.Add(new prccabMap());
            modelBuilder.Configurations.Add(new prcprdMap());
            modelBuilder.Configurations.Add(new prcprdbkMap());
            modelBuilder.Configurations.Add(new prcprdfatMap());
            modelBuilder.Configurations.Add(new prcprdfatbkMap());
            modelBuilder.Configurations.Add(new prdchbMap());
            modelBuilder.Configurations.Add(new prdfamMap());
            modelBuilder.Configurations.Add(new PRDFAM_GENGRPPRCMap());
            modelBuilder.Configurations.Add(new prdgrpMap());
            modelBuilder.Configurations.Add(new prdgrpAuxiliarMap());
            modelBuilder.Configurations.Add(new prdorcMap());
            modelBuilder.Configurations.Add(new RegrasCalculoMap());
            modelBuilder.Configurations.Add(new RelatorioMap());
            modelBuilder.Configurations.Add(new SecaoMap());
            modelBuilder.Configurations.Add(new sysdiagramMap());
            modelBuilder.Configurations.Add(new tab_cadastrosMap());
            modelBuilder.Configurations.Add(new TABGRPIMPMap());
            modelBuilder.Configurations.Add(new TABREGRAMap());
            modelBuilder.Configurations.Add(new TABREGRA_backupMap());
            modelBuilder.Configurations.Add(new TABTIPVENMap());
            modelBuilder.Configurations.Add(new tabufMap());
            modelBuilder.Configurations.Add(new tbl_consumo_tipoMap());
            modelBuilder.Configurations.Add(new tbl_tipo_cobrarMap());
            modelBuilder.Configurations.Add(new tblDados_projetoMap());
            modelBuilder.Configurations.Add(new tblDescontoMap());
            modelBuilder.Configurations.Add(new tblGrupoBuscaMap());
            modelBuilder.Configurations.Add(new tblOpcaoMap());
            modelBuilder.Configurations.Add(new TBLPAIMap());
            modelBuilder.Configurations.Add(new tblPgtCabMap());
            modelBuilder.Configurations.Add(new tblPgtCabModalidadeMap());
            modelBuilder.Configurations.Add(new tblPrzMedMap());
            modelBuilder.Configurations.Add(new tipo_Alt_conceitoMap());
            modelBuilder.Configurations.Add(new tipo_Compr_conceitoMap());
            modelBuilder.Configurations.Add(new tipo_desenharMap());
            modelBuilder.Configurations.Add(new Tipo_Inc_no_modMap());
            modelBuilder.Configurations.Add(new tipo_insercaoMap());
            modelBuilder.Configurations.Add(new tipo_prof_conceitoMap());
            modelBuilder.Configurations.Add(new tipo_qtde_p_nivel_formulaMap());
            modelBuilder.Configurations.Add(new tipo_resfriamentoMap());
            modelBuilder.Configurations.Add(new tipo_tipoMap());
            modelBuilder.Configurations.Add(new tipo_variacaoMap());
            modelBuilder.Configurations.Add(new TipoItemMap());
            modelBuilder.Configurations.Add(new TiposAcoMap());
            modelBuilder.Configurations.Add(new TraducaoMap());
            modelBuilder.Configurations.Add(new TstCabMap());
            modelBuilder.Configurations.Add(new tubula_gas_refrigeranteMap());
            modelBuilder.Configurations.Add(new UsuarioMap());
            modelBuilder.Configurations.Add(new varusrMap());
            modelBuilder.Configurations.Add(new varusr_rel_tipoMap());
            modelBuilder.Configurations.Add(new varusrorcMap());
            modelBuilder.Configurations.Add(new TABLES_AND_COLUMNS_VIEWMap());
        }
    }
}
