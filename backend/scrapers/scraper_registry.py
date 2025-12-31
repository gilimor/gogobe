#!/usr/bin/env python3
"""
SCRAPER REGISTRY - Enhanced with KingStore
Dynamic scraper management without IF statements
"""
import logging
from typing import Dict, Optional, Any
from datetime import datetime

logger = logging.getLogger(__name__)


class ScraperConfig:
    """Configuration for a single scraper"""
    def __init__(
        self,
        source_id: str,
        scraper_class: str,
        module_path: str,
        enabled: bool = True,
        requires_auth: bool = False,
        credentials: Optional[Dict[str, str]] = None,
        init_args: Optional[Dict[str, Any]] = None,
        last_import: Optional[datetime] = None,
        metadata: Optional[Dict[str, Any]] = None
    ):
        self.source_id = source_id
        self.scraper_class = scraper_class
        self.module_path = module_path
        self.enabled = enabled
        self.enabled = enabled
        self.requires_auth = requires_auth
        self.credentials = credentials or {}
        self.init_args = init_args or {}
        self.last_import = last_import
        self.metadata = metadata or {}
        self._instance = None
        self.last_error = None  # NEW: Store error for debugging
    
    def is_available(self) -> bool:
        """Check if scraper is available (not in maintenance, enabled, etc)"""
        if not self.enabled:
            return False
        return True
    
    def get_instance(self):
        """Lazy load scraper instance"""
        if self._instance is None:
            try:
                # Dynamic import
                module = __import__(self.module_path, fromlist=[self.scraper_class])
                scraper_cls = getattr(module, self.scraper_class)
                
                # Combine credentials and init_args
                kwargs = {**self.init_args} 
                if self.requires_auth:
                    kwargs.update(self.credentials)

                self._instance = scraper_cls(**kwargs)
                
                logger.info(f"✓ Loaded scraper: {self.source_id}")
                self.last_error = None
                
            except Exception as e:
                err_msg = f"Failed to load scraper {self.source_id}: {str(e)}"
                logger.error(f"âœ— {err_msg}")
                self.last_error = str(e)  # Capture error
                raise Exception(err_msg)
        
        return self._instance


class ScraperRegistry:
    """
    Central registry for all scrapers
    No IF statements - purely data-driven
    """
    
    def __init__(self):
        self._scrapers: Dict[str, ScraperConfig] = {}
        self._load_default_scrapers()
    
    def _load_default_scrapers(self):
        """Load default scraper configurations"""
        
        # Shufersal
        self.register(ScraperConfig(
            source_id='shufersal',
            scraper_class='ShufersalScraper',
            module_path='scrapers.shufersal_scraper',
            enabled=True,
            requires_auth=False,
            metadata={
                'description': 'Shufersal - Israeli supermarket chain',
                'category': 'supermarket'
            }
        ))
        
        # SuperPharm
        self.register(ScraperConfig(
            source_id='superpharm',
            scraper_class='SuperPharmScraper',
            module_path='scrapers.superpharm_scraper',
            enabled=True,
            requires_auth=False,
            metadata={
                'description': 'SuperPharm - Israeli pharmacy chain',
                'category': 'pharmacy'
            }
        ))
        

        
        # Rami Levy (needs credentials)
        self.register(ScraperConfig(
            source_id='rami_levy',
            scraper_class='RamiLevyScraper',
            module_path='scrapers.rami_levy_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'username': 'RamiLevi',
                'password': ''
            },
            metadata={
                'description': 'Rami Levy',
                'category': 'supermarket'
            }
        ))
        
        
        
        # Dor Alon
        self.register(ScraperConfig(
            source_id='dor_alon',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'doralon',
                'platform_pass': ''
            },
            init_args={
                'chain_name': 'Dor Alon',
                'chain_slug': 'dor_alon',
                'chain_name_he': 'דור אלון',
                'chain_id': '7290000000000'
            },
            metadata={
                'description': 'Dor Alon - Convenience Stores & Fuel',
                'category': 'convenience',
                'country': 'IL'
            }
        ))

        # Saleh Dabbah
        self.register(ScraperConfig(
            source_id='saleh_dabbah',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'SalachD',
                'platform_pass': '12345'
            },
            init_args={
                'chain_name': 'Saleh Dabbah',
                'chain_slug': 'saleh_dabbah',
                'chain_name_he': 'סאלח דבאח',
                'chain_id': '7290633800006' # Verified from test searches often, or safe guess
            },
            metadata={
                'description': 'Saleh Dabbah - Meat & Supermarket',
                'category': 'supermarket',
                'country': 'IL'
            }
        ))

        # Stop Market
        self.register(ScraperConfig(
            source_id='stop_market',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'Stop_Market',
                'platform_pass': ''
            },
            init_args={
                'chain_name': 'Stop Market',
                'chain_slug': 'stop_market',
                'chain_name_he': 'סטופ מרקט',
                'chain_id': '7290172911110' # Dummy
            },
            metadata={
                'description': 'Stop Market',
                'category': 'supermarket',
                'country': 'IL'
            }
        ))

        # Politzer
        self.register(ScraperConfig(
            source_id='politzer',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'politzer',
                'platform_pass': ''
            },
            init_args={
                'chain_name': 'Politzer',
                'chain_slug': 'politzer',
                'chain_name_he': 'פוליצר',
                'chain_id': '7290000000000'
            },
            metadata={
                'description': 'Politzer',
                'category': 'supermarket',
                'country': 'IL'
            }
        ))

        # Paz Yellow
        self.register(ScraperConfig(
            source_id='paz_yellow',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'Paz_bo',
                'platform_pass': 'paz468'
            },
            init_args={
                'chain_name': 'Paz Yellow',
                'chain_slug': 'paz_yellow',
                'chain_name_he': 'פז ילו',
                'chain_id': '7290000000000'
            },
            metadata={
                'description': 'Yellow (Paz) - Convenience Stores',
                'category': 'convenience',
                'country': 'IL'
            }
        ))

        # Super Yuda
        self.register(ScraperConfig(
            source_id='super_yuda',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'yuda_ho',
                'platform_pass': 'Yud@147'
            },
            init_args={
                'chain_name': 'Super Yuda',
                'chain_slug': 'super_yuda',
                'chain_name_he': 'סופר יודה',
                'chain_id': '7290000000000'
            },
            metadata={
                'description': 'Super Yuda',
                'category': 'supermarket',
                'country': 'IL'
            }
        ))

        # Keshet Taamim
        self.register(ScraperConfig(
            source_id='keshet_taamim',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'Keshet',
                'platform_pass': ''
            },
            init_args={
                'chain_name': 'Keshet Taamim',
                'chain_slug': 'keshet_taamim',
                'chain_name_he': 'קשת טעמים',
                'chain_id': '7290000000000'
            },
            metadata={
                'description': 'Keshet Taamim',
                'category': 'supermarket',
                'country': 'IL'
            }
        ))

        # Super Cofix (Under Rami Levy Group but separate user)
        self.register(ScraperConfig(
            source_id='super_cofix',
            scraper_class='PublishedPricesScraper',
            module_path='scrapers.published_prices_scraper',
            enabled=True,
            requires_auth=True,
            credentials={
                'platform_user': 'SuperCofixApp',
                'platform_pass': ''
            },
            init_args={
                'chain_name': 'Super Cofix',
                'chain_slug': 'super_cofix',
                'chain_name_he': 'סופר קופיקס',
                'chain_id': '7290000000000'
            },
            metadata={
                'description': 'Super Cofix',
                'category': 'supermarket',
                'country': 'IL'
            }
        ))


        # --- Chains requiring ChainID Discovery (BinaProjects / LaibCatalog) ---
        
        # King Store
        # King Store
        self.register(ScraperConfig(
            source_id='king_store',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=True,
            init_args={
                'chain_name': 'King Store',
                'chain_slug': 'kingstore',
                'chain_name_he': 'קינג סטור',
                'chain_id': '7290058108879',
                'subdomain': 'kingstore'
            },
            metadata={
                'description': 'King Store',
                'category': 'supermarket',
                'subdomain': 'kingstore'
            }
        ))

        # Maayan 2000
        self.register(ScraperConfig(
            source_id='maayan2000',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=True,
            init_args={
                'chain_name': 'Maayan 2000',
                'chain_slug': 'maayan2000',
                'chain_name_he': 'מעיין 2000',
                'chain_id': '7290058159628',
                'subdomain': 'maayan2000'
            },
            metadata={
                'description': 'Maayan 2000',
                'category': 'supermarket',
                'subdomain': 'maayan2000'
            }
        ))
        
        # Good Pharm
        self.register(ScraperConfig(
            source_id='good_pharm',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=False,
            metadata={
                'description': 'Good Pharm',
                'category': 'pharmacy',
                'subdomain': 'goodpharm'
            }
        ))
        
        # Zol VeBegadol
        self.register(ScraperConfig(
            source_id='zol_vebegadol',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=False,
            metadata={
                'description': 'Zol VeBegadol',
                'category': 'supermarket',
                'subdomain': 'zolvebegadol'
            }
        ))

        # Super Sapir
        self.register(ScraperConfig(
            source_id='super_sapir',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=False,
            metadata={
                'description': 'Super Sapir',
                'category': 'supermarket',
                'subdomain': 'supersapir'
            }
        ))
        
        # Super Bareket
        self.register(ScraperConfig(
            source_id='super_bareket',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=False,
            metadata={
                'description': 'Super Bareket',
                'category': 'supermarket',
                'subdomain': 'superbareket'
            }
        ))
        
        # Shuk Ha'ir
        self.register(ScraperConfig(
            source_id='shuk_hair',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=False,
            metadata={
                'description': 'Shuk Ha\'ir',
                'category': 'supermarket',
                'subdomain': 'shuk-hayir'
            }
        ))
        
        # Shefa Birkat Hashem
        self.register(ScraperConfig(
            source_id='shefa_birkat_hashem',
            scraper_class='BinaProjectsScraper',
            module_path='scrapers.bina_projects_scraper',
            enabled=False,
            metadata={
                'description': 'Shefa Birkat Hashem',
                'category': 'supermarket',
                'subdomain': 'shefabirkathashem'
            }
        ))
        
        # Mahsanei HaShuk (LaibCatalog)
        self.register(ScraperConfig(
            source_id='mahsanei_hashuk',
            scraper_class='LaibCatalogScraper',
            module_path='scrapers.laib_catalog_scraper',
            enabled=False, # Missing ChainID
            metadata={
                'description': 'Mahsanei HaShuk',
                'category': 'supermarket'
            }
        ))

        # Fresh Market (requires login)
        self.register(ScraperConfig(
            source_id='fresh_market',
            scraper_class='FreshMarketScraper',
            module_path='scrapers.fresh_market_scraper',  # FIXED: module path
            enabled=True,
            requires_auth=True,
            credentials={
                'username': 'freshmarket',
                'password': ''
            },
            metadata={
                'description': 'Fresh Market - Israeli fresh produce supermarket (with login)',
                'category': 'supermarket',
                'url': 'https://freshmarket.co.il'
            }
        ))
        
        
        # Victory (Specific Class)
        self.register(ScraperConfig(
            source_id='victory',
            scraper_class='VictoryScraper',
            module_path='scrapers.victory_scraper',
            enabled=True,
            requires_auth=False, # Auth handled internally
            metadata={
                'description': 'Victory Supermarket',
                'category': 'supermarket'
            }
        ))

        # Tiv Taam (Specific Class)
        self.register(ScraperConfig(
            source_id='tiv_taam',
            scraper_class='TivTaamScraper',
            module_path='scrapers.tiv_taam_scraper',
            enabled=True,
            requires_auth=False, # Auth handled internally
            metadata={
                'description': 'Tiv Taam',
                'category': 'supermarket'
            }
        ))

        # Yohananof (Specific Class)
        self.register(ScraperConfig(
            source_id='yohananof',
            scraper_class='YohananofScraper',
            module_path='scrapers.yohananof_scraper',
            enabled=True,
            requires_auth=False, # Auth handled internally
            metadata={
                'description': 'Yohananof',
                'category': 'supermarket'
            }
        ))

        # Walmart I/O (API)
        self.register(ScraperConfig(
            source_id='walmart',
            scraper_class='WalmartScraper',
            module_path='scrapers.walmart_scraper',
            enabled=False, # Simulation Mode
            requires_auth=True, # Needs Keys
            credentials={
                'client_id': '', # User must fill
                'client_secret': ''
            },
            metadata={
                'description': 'Walmart US (API)',
                'category': 'supermarket_global',
                'country': 'US'
            }
        ))

        # Open Food Facts (Example of enrichment source)
        self.register(ScraperConfig(
            source_id='openfoodfacts',
            scraper_class='OpenFoodFactsScraper',
            module_path='scrapers.openfoodfacts_scraper',
            enabled=False,
            requires_auth=False,
            metadata={
                'description': 'Open Food Facts Global Database',
                'category': 'enrichment',
                'country': 'GLOBAL'
            }
        ))
        
        # Italy Fuel (MIMIT)
        self.register(ScraperConfig(
            source_id='mimit_fuel',
            scraper_class='ItalyFuelScraper',
            module_path='scrapers.italy_fuel_scraper',
            enabled=True,
            requires_auth=False,
            metadata={
                'description': 'MIMIT - Italian Fuel Prices (Daily)',
                'category': 'fuel',
                'country': 'IT',
                'url': 'https://www.mimit.gov.it/it/open-data/elenco-dataset/carburanti-prezzi-praticati-e-anagrafica-degli-impianti'
            }
        ))
        
        # France Fuel (Gov)
        self.register(ScraperConfig(
            source_id='france_fuel',
            scraper_class='FranceFuelScraper',
            module_path='scrapers.france_fuel_scraper',
            enabled=True,
            requires_auth=False,
            metadata={
                'description': 'Prix Carburants - France Government Data (Liquid)',
                'category': 'fuel',
                'country': 'FR',
                'url': 'https://www.prix-carburants.gouv.fr/rubrique/opendata/'
            }
        ))
        
        # WA Fuel (Australia)
        self.register(ScraperConfig(
            source_id='wa_fuel',
            scraper_class='WAFuelScraper',
            module_path='scrapers.wa_fuel_scraper',
            enabled=True,
            requires_auth=False,
            metadata={
                'description': 'FuelWatch - Western Australia (RSS)',
                'category': 'fuel',
                'country': 'AU',
                'url': 'https://www.fuelwatch.wa.gov.au/'
            }
        ))

        # Tokyo Market
        self.register(ScraperConfig(
            source_id='tokyo_wholesale',
            scraper_class='TokyoMarketScraper',
            module_path='scrapers.tokyo_market_scraper',
            enabled=True,
            requires_auth=False,
            metadata={
                'description': 'Tokyo Central Wholesale Market (Toyosu)',
                'category': 'wholesale',
                'country': 'JP',
                'url': 'https://www.shijou-nippo.metro.tokyo.lg.jp/'
            }
        ))
        
        # Spain Fuel (Geoportal)
        self.register(ScraperConfig(
            source_id='spain_fuel',
            scraper_class='SpainFuelScraper',
            module_path='scrapers.spain_fuel_scraper',
            enabled=True,
            requires_auth=False,
            metadata={
                'description': 'Geoportal Gasolineras - Spain',
                'category': 'fuel',
                'country': 'ES',
                'url': 'https://geoportalgasolineras.es/'
            }
        ))
        
        # L.K. LTD
        self.register(ScraperConfig(
            source_id='lkltd',
            scraper_class='LKLtdScraper',
            module_path='scrapers.lkltd_scraper',
            enabled=True,
            metadata={
                'description': 'L.K. Ltd - Tools & Equipment',
                'category': 'tools',
                'url': 'https://www.lkltd.co.il/'
            }
        ))
        
        # Future suppliers can be added here or loaded from DB/config file
    
    def register(self, config: ScraperConfig):
        """Register a new scraper"""
        self._scrapers[config.source_id] = config
        logger.info(f"Registered scraper: {config.source_id}")
    
    def get(self, source_id: str) -> Optional[Any]:
        """
        Get scraper instance by source_id
        Returns None if not available (maintenance, disabled, error)
        """
        config = self._scrapers.get(source_id)
        
        if not config:
            logger.warning(f"Unknown scraper: {source_id}")
            return None
        
        if not config.is_available():
            logger.warning(f"Scraper not available: {source_id}")
            return None
        
        try:
            return config.get_instance()
        except Exception as e:
            logger.error(f"Failed to get scraper {source_id}: {e}")
            return None
    
    def get_all_enabled(self) -> Dict[str, Any]:
        """Get all enabled scraper instances"""
        result = {}
        for source_id, config in self._scrapers.items():
            if config.is_available():
                try:
                    result[source_id] = config.get_instance()
                except Exception as e:
                    logger.error(f"Skipping {source_id}: {e}")
        return result
    
    def disable(self, source_id: str, reason: str = ""):
        """Disable a scraper (e.g., during maintenance)"""
        if source_id in self._scrapers:
            self._scrapers[source_id].enabled = False
            logger.info(f"Disabled {source_id}: {reason}")
    
    def enable(self, source_id: str):
        """Enable a scraper"""
        if source_id in self._scrapers:
            self._scrapers[source_id].enabled = True
            logger.info(f"Enabled {source_id}")
    
    def update_last_import(self, source_id: str, timestamp: datetime):
        """Update last import timestamp"""
        if source_id in self._scrapers:
            self._scrapers[source_id].last_import = timestamp
    
    def get_status(self) -> Dict[str, Dict[str, Any]]:
        """Get status of all scrapers"""
        return {
            source_id: {
                'enabled': config.enabled,
                'available': config.is_available(),
                'requires_auth': config.requires_auth,
                'last_import': config.last_import.isoformat() if config.last_import else None,
                'last_error': config.last_error,  # NEW: Show error in UI
                'metadata': config.metadata
            }
            for source_id, config in self._scrapers.items()
        }


# Global singleton instance
_registry = None


def get_registry() -> ScraperRegistry:
    """Get global scraper registry"""
    global _registry
    if _registry is None:
        _registry = ScraperRegistry()
    return _registry


