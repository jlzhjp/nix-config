final: prev: {
  clojure = prev.clojure.override {
    jdk = final.jdk25;
  };

  babashka = prev.babashka.override {
    jdkBabashka = final.jdk25;

    clojureToolsBabashka = prev.babashka.passthru.clojure-tools.override {
      inherit (final) clojure;
    };
  };

  neil = prev.neil.override {
    inherit (final) babashka;
  };
}
